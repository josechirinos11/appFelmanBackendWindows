import dotenv from 'dotenv';
dotenv.config();
import ADODB from 'node-adodb';
import fs from 'fs';

if (!process.env.DB_PATH) throw new Error('DB_PATH no definida');
if (!process.env.DB_PROVIDER) throw new Error('DB_PROVIDER no definida');

const dbConfig = {
    provider: process.env.DB_PROVIDER,
    database: process.env.DB_PATH
};

class AccessDB {
    private static instance: AccessDB;
    private connection: any;

    private constructor() {
        if (!fs.existsSync(dbConfig.database)) {
            throw new Error('La base de datos no existe en: ' + dbConfig.database);
        }
        process.env.ADODB_EXECUTABLE = 'C:\\Windows\\SysWOW64\\cscript.exe';
        const connectionString = [
            'Provider=' + dbConfig.provider,
            'Data Source=' + dbConfig.database,
            'Mode=Read',
            'Persist Security Info=False',
            'User ID=Admin',
            'Password='
        ].join(';');
        this.connection = ADODB.open(connectionString);
    }

    public static getInstance(): AccessDB {
        if (!AccessDB.instance) AccessDB.instance = new AccessDB();
        return AccessDB.instance;
    }

    public async query(sql: string, params?: any[]): Promise<any> {
        return await this.connection.query(sql);
    }

    public async execute(sql: string, params?: any[]): Promise<void> {
        await this.connection.execute(sql);
    }

    public async testConnection(): Promise<boolean> {
        const result = await this.connection.query('SELECT 1 AS Test');
        return Array.isArray(result);
    }
}

export const db = AccessDB.getInstance();
