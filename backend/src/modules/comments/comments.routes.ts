import { Router } from 'express';
import * as commentsController from './comments.controller';

const router = Router();

router.get('/', commentsController.list);
router.get('/:id', commentsController.getById);
router.post('/', commentsController.create);
router.put('/:id', commentsController.update);
router.delete('/:id', commentsController.remove);

export default router;