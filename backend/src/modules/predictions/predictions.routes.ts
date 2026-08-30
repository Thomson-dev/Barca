import { Router } from 'express';
import * as predictionsController from './predictions.controller';

const router = Router();

router.get('/', predictionsController.list);
router.get('/:id', predictionsController.getById);
router.post('/', predictionsController.create);
router.put('/:id', predictionsController.update);
router.delete('/:id', predictionsController.remove);

export default router;