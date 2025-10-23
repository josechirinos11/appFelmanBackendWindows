import { Router } from 'express';
import { DatabaseController } from '../controllers/database.controller';

const router = Router();
const controller = new DatabaseController();

// Rutas para operaciones de base de datos
router.get('/test-connection', (req, res) => controller.testConnection(req, res));
router.post('/query', (req, res) => controller.executeQuery(req, res));
router.post('/execute', (req, res) => controller.executeCommand(req, res));

export default router;
