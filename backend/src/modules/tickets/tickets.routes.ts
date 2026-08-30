import { Router } from 'express';
import * as ticketsController from './tickets.controller';

const router = Router();

router.get('/', ticketsController.list);
router.get('/:id', ticketsController.getById);
router.post('/', ticketsController.create);
router.put('/:id', ticketsController.update);
router.delete('/:id', ticketsController.remove);

export default router;