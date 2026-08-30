import { Router } from 'express';
import * as videosController from './videos.controller';

const router = Router();

router.get('/', videosController.list);
router.get('/:id', videosController.getById);
router.post('/', videosController.create);
router.put('/:id', videosController.update);
router.delete('/:id', videosController.remove);

export default router;