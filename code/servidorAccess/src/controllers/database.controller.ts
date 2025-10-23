import { Request, Response } from 'express';
import { db } from '../config/database';

export class DatabaseController {
    public async testConnection(req: Request, res: Response): Promise<void> {
        try {
            console.log('Iniciando prueba de conexión...');
            console.log('Configuración:', {
                path: process.env.DB_PATH,
                provider: process.env.DB_PROVIDER,
                arch: process.arch,
                platform: process.platform,
                nodeVersion: process.version
            });

            const isConnected = await db.testConnection();
            
            if (isConnected) {
                res.json({ 
                    status: 'success', 
                    message: 'Conexión exitosa a la base de datos',
                    config: {
                        dbPath: process.env.DB_PATH,
                        dbProvider: process.env.DB_PROVIDER,
                        nodeArch: process.arch,
                        platform: process.platform
                    }
                });
            } else {
                res.status(500).json({ 
                    status: 'error', 
                    message: 'La prueba de conexión falló sin error específico',
                    config: {
                        dbPath: process.env.DB_PATH,
                        dbProvider: process.env.DB_PROVIDER,
                        nodeArch: process.arch,
                        platform: process.platform
                    }
                });
            }
        } catch (error: any) {
            console.error('Error detallado:', {
                message: error.message,
                stack: error.stack,
                code: error.code,
                state: error.state
            });
            
            res.status(500).json({ 
                status: 'error', 
                message: 'Error al probar la conexión', 
                error: error.message || error,
                errorCode: error.code,
                errorState: error.state,
                config: {
                    dbPath: process.env.DB_PATH,
                    dbProvider: process.env.DB_PROVIDER,
                    nodeArch: process.arch,
                    platform: process.platform
                }
            });
        }
    }

    public async executeQuery(req: Request, res: Response): Promise<void> {
        try {
            const { sql, params } = req.body;
            if (!sql) {
                res.status(400).json({ status: 'error', message: 'SQL query is required' });
                return;
            }

            const result = await db.query(sql, params || []);
            res.json({ status: 'success', data: result });
        } catch (error) {
            res.status(500).json({ status: 'error', message: 'Error executing query', error });
        }
    }

    public async executeCommand(req: Request, res: Response): Promise<void> {
        try {
            const { sql, params } = req.body;
            if (!sql) {
                res.status(400).json({ status: 'error', message: 'SQL command is required' });
                return;
            }

            await db.execute(sql, params || []);
            res.json({ status: 'success', message: 'Command executed successfully' });
        } catch (error) {
            res.status(500).json({ status: 'error', message: 'Error executing command', error });
        }
    }
}
