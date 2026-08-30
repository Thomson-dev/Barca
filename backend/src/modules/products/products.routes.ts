import { Router } from 'express';
import * as productsController from './products.controller';

const router = Router();

router.get('/', productsController.list);
router.get('/:id', productsController.getById);
router.post('/', productsController.create);
router.put('/:id', productsController.update);
router.delete('/:id', productsController.remove);

export default router;