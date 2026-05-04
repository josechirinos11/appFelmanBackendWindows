import { Router } from 'express';
import { DatabaseController } from '../controllers/database.controller';
import { db } from '../config/database';

const router = Router();
const controller = new DatabaseController();

router.get('/test-connection', (req, res) => controller.testConnection(req, res));
router.post('/query', (req, res) => controller.executeQuery(req, res));
router.post('/execute', (req, res) => controller.executeCommand(req, res));

router.get('/control-access/pedidosComercialesJeronimoN8N_completa_tipoTrabajo', async (req, res) => {
    try {
        const sql = 'SELECT NoPedido, FechaEnvio, Seccion, Cliente, Comercial, EmailComercial, RefCliente, Compromiso, EstadoPedido, ColorGeneral, FechaAltaPedido, FormatoTrabajo, Unidades_del_Pedido, Orden FROM pedidosComercialesJeronimoN8N_completa_tipoTrabajo';
        const result = await db.query(sql);
        res.json(result);
    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
});

export default router;
