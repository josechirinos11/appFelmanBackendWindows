import mongoose from 'mongoose';
import bcrypt from 'bcryptjs';

const MONGO_URI = process.env.MONGO_URI || '';

const usuarioSchema = new mongoose.Schema({
  email: String,
  password: String,
  nombre: String,
  rol: String
});

const Usuario = mongoose.models.Usuario || mongoose.model('Usuario', usuarioSchema, 'CollectionSoria');

let isConnected = false;

export const handler = async (event) => {
  try {
    const body = JSON.parse(event.body || '{}');
    const { email, password, nombre } = body;

    if (!isConnected) {
      await mongoose.connect(MONGO_URI);
      isConnected = true;
    }

    // Registro
    if (event.path === '/register' && event.httpMethod === 'POST') {
      if (!email || !password || !nombre) {
        return {
          statusCode: 400,
          body: JSON.stringify({ success: false, msg: 'Todos los campos son requeridos' })
        };
      }
      const existeUsuario = await Usuario.findOne({ email });
      if (existeUsuario) {
        return {
          statusCode: 409,
          body: JSON.stringify({ success: false, msg: 'El usuario ya existe' })
        };
      }
      const hashedPassword = await bcrypt.hash(password, 10);
      const nuevoUsuario = new Usuario({
        email,
        password: hashedPassword,
        nombre,
        rol: 'usuario'
      });
      await nuevoUsuario.save();
      return {
        statusCode: 201,
        body: JSON.stringify({ success: true, msg: 'Usuario creado correctamente' })
      };
    }

    // Login
    if (event.path === '/login' && event.httpMethod === 'POST') {
      if (!email || !password) {
        return {
          statusCode: 400,
          body: JSON.stringify({ success: false, error: 'Email y contraseña requeridos' })
        };
      }
      const usuario = await Usuario.findOne({ email });
      if (!usuario) {
        return {
          statusCode: 401,
          body: JSON.stringify({ success: false, error: 'Usuario no encontrado' })
        };
      }
      const match = await bcrypt.compare(password, usuario.password);
      if (!match) {
        return {
          statusCode: 401,
          body: JSON.stringify({ success: false, error: 'Contraseña incorrecta' })
        };
      }
      return {
        statusCode: 200,
        body: JSON.stringify({
          success: true,
          usuario: {
            id: usuario._id,
            nombre: usuario.nombre,
            email: usuario.email,
            rol: usuario.rol
          }
        })
      };
    }

    // Ruta no soportada
    return {
      statusCode: 404,
      body: JSON.stringify({ success: false, error: 'Ruta no soportada' })
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ success: false, error: error.message })
    };
  }
};