import dotenv from 'dotenv';
// Cargar variables de entorno al inicio
dotenv.config();

// Verificar que las variables de entorno se cargaron correctamente
console.log('Variables de entorno cargadas:');
console.log('DB_PATH:', process.env.DB_PATH);
console.log('DB_PROVIDER:', process.env.DB_PROVIDER);

import cors from 'cors';
import express from 'express';
import databaseRoutes from './routes/database.routes';

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors({
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json());

// Manejo de errores global
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
    console.error('Error detallado:', err);
    res.status(500).json({
        status: 'error',
        message: err.message || 'Error interno del servidor',
        details: process.env.NODE_ENV === 'development' ? err : undefined
    });
});

// Rutas
app.use('/api', databaseRoutes);

// Ruta de prueba
app.get('/', (req, res) => {
    res.json({ 
        message: 'Servidor Access API funcionando correctamente',
        environment: {
            nodeVersion: process.version,
            platform: process.platform,
            arch: process.arch
        }
    });
});

// Iniciar servidor
const serverPort = parseInt(port.toString(), 10);
app.listen(serverPort, '0.0.0.0', () => {
    console.log(`🚀 Servidor iniciado en http://localhost:${serverPort}`);
    console.log(`Base de datos configurada en: ${process.env.DB_PATH}`);
    console.log(`Proveedor de base de datos: ${process.env.DB_PROVIDER}`);
});
