import mongoose from 'mongoose';
import bcrypt from 'bcryptjs';

const MONGO_URI = process.env.MONGO_URI || '';

const usuarioSchema = new mongoose.Schema({
  email: String,
  password: String,
  nombre: String,
  rol: String
});
const Usuario = mongoose.models.Usuario || mongoose.model('Usuario', usuarioSchema);

let isConnected = false;

export const handler = async (event) => {
  try {
    const { email, password } = JSON.parse(event.body || '{}');
    if (!email || !password) {
      return {
        statusCode: 400,
        body: JSON.stringify({ success: false, error: 'Email y contraseña requeridos' })
      };
    }
    if (!isConnected) {
      await mongoose.connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true });
      isConnected = true;
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
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ success: false, error: error.message })
    };
  }
};