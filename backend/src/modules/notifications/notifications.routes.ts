import { Router } from 'express';
import * as notificationsController from './notifications.controller';

const router = Router();

router.get('/', notificationsController.list);
router.get('/:id', notificationsController.getById);
router.post('/', notificationsController.create);
router.put('/:id', notificationsController.update);
router.delete('/:id', notificationsController.remove);

export default router;