import { Router } from 'express';
import * as newsController from './news.controller';

const router = Router();

router.get('/', newsController.list);
router.get('/:id', newsController.getById);
router.post('/', newsController.create);
router.put('/:id', newsController.update);
router.delete('/:id', newsController.remove);

export default router;