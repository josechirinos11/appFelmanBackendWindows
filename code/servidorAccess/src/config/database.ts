import ADODB from 'node-adodb';
import fs from 'fs';
import path from 'path';

// Verificación inicial de variables de entorno
if (!process.env.DB_PATH) {
    throw new Error('La variable de entorno DB_PATH no está definida');
}

if (!process.env.DB_PROVIDER) {
    throw new Error('La variable de entorno DB_PROVIDER no está definida');
}

// Configuración de la base de datos Access
const dbConfig = {
    provider: process.env.DB_PROVIDER,
    database: process.env.DB_PATH
};

class AccessDB {
    private static instance: AccessDB;
    private connection: any;

    private constructor() {
        try {
            // Verificar que el archivo existe
            if (!fs.existsSync(dbConfig.database)) {
                throw new Error(`La base de datos no existe en la ruta: ${dbConfig.database}`);
            }
            
            console.log('Archivo de base de datos encontrado:', dbConfig.database);
            const stats = fs.statSync(dbConfig.database);
            console.log('Tamaño de la base de datos:', stats.size, 'bytes');

            // Verificar que cscript.exe existe y configurarlo
            const cscriptPath = 'C:\\Windows\\System32\\cscript.exe';
            if (!fs.existsSync(cscriptPath)) {
                throw new Error(`No se encontró cscript.exe en ${cscriptPath}`);
            }
            process.env.ADODB_EXECUTABLE = cscriptPath;            // Crear la cadena de conexión
            const connectionString = [
                `Provider=${dbConfig.provider}`,
                `Data Source=${dbConfig.database}`,
                'Mode=ReadWrite|Share Deny None',
                'Persist Security Info=True',
                'Jet OLEDB:System Database=system.mdw',
                'Jet OLEDB:Database Password=',
                'Jet OLEDB:Engine Type=5',
                'Jet OLEDB:Database Locking Mode=1',
                'Jet OLEDB:Global Partial Bulk Ops=2',
                'User ID=Admin',
                'Password='
            ].join(';');

            console.log('Intentando conexión con cadena:', connectionString);
            this.connection = ADODB.open(connectionString);

        } catch (error) {
            console.error('Error al inicializar la conexión:', error);
            throw error;
        }
    }

    public static getInstance(): AccessDB {
        if (!AccessDB.instance) {
            AccessDB.instance = new AccessDB();
        }
        return AccessDB.instance;
    }    public async testConnection(): Promise<boolean> {
        try {
            // Intentar una consulta extremadamente simple
            console.log('Ejecutando consulta de prueba básica...');
            const result = await this.connection.query('SELECT "Test" AS Result FROM (SELECT 1 AS Dummy)');
            console.log('Resultado de la prueba:', result);
            return Array.isArray(result);
        } catch (error: any) {
            // Capturar más detalles del error
            const errorDetails = {
                message: error.message,
                stack: error.stack,
                code: error.code,
                state: error.state,
                path: dbConfig.database,
                provider: dbConfig.provider
            };
            console.error('Error detallado en la prueba de conexión:', errorDetails);
            throw error;
        }
    }
}

export const db = AccessDB.getInstance();
