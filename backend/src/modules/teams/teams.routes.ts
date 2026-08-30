import { Router } from 'express';
import * as teamsController from './teams.controller';

const router = Router();

router.get('/', teamsController.list);
router.get('/:id', teamsController.getById);
router.post('/', teamsController.create);
router.put('/:id', teamsController.update);
router.delete('/:id', teamsController.remove);

export default router;