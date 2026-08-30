import { Router } from 'express';
import * as playersController from './players.controller';

const router = Router();

router.get('/', playersController.list);
router.get('/:id', playersController.getById);
router.post('/', playersController.create);
router.put('/:id', playersController.update);
router.delete('/:id', playersController.remove);

export default router;