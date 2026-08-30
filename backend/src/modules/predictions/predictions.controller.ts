import { Request, Response, NextFunction } from 'express';
import predictionsService from './predictions.service';

export const list = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const result = await predictionsService.list();
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

export const getById = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const result = await predictionsService.getById(req.params.id);
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

export const create = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const result = await predictionsService.create(req.body);
    res.status(201).json(result);
  } catch (err) {
    next(err);
  }
};

export const update = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const result = await predictionsService.update(req.params.id, req.body);
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

export const remove = async (req: Request, res: Response, next: NextFunction) => {
  try {
    await predictionsService.remove(req.params.id);
    res.status(204).send();
  } catch (err) {
    next(err);
  }
};