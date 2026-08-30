import { Router } from 'express';
import * as matchesController from './matches.controller';

const router = Router();

router.get('/', matchesController.list);
router.get('/:id', matchesController.getById);
router.post('/', matchesController.create);
router.put('/:id', matchesController.update);
router.delete('/:id', matchesController.remove);

export default router;