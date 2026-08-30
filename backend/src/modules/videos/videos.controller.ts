import { Request, Response, NextFunction } from 'express';
import videosService from './videos.service';

export const list = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const result = await videosService.list();
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

export const getById = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const result = await videosService.getById(req.params.id);
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

export const create = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const result = await videosService.create(req.body);
    res.status(201).json(result);
  } catch (err) {
    next(err);
  }
};

export const update = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const result = await videosService.update(req.params.id, req.body);
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

export const remove = async (req: Request, res: Response, next: NextFunction) => {
  try {
    await videosService.remove(req.params.id);
    res.status(204).send();
  } catch (err) {
    next(err);
  }
};