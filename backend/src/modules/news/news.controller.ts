import { Request, Response, NextFunction } from 'express';
import newsService from './news.service';

export const list = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const result = await newsService.list();
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

export const getById = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const result = await newsService.getById(req.params.id);
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

export const create = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const result = await newsService.create(req.body);
    res.status(201).json(result);
  } catch (err) {
    next(err);
  }
};

export const update = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const result = await newsService.update(req.params.id, req.body);
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

export const remove = async (req: Request, res: Response, next: NextFunction) => {
  try {
    await newsService.remove(req.params.id);
    res.status(204).send();
  } catch (err) {
    next(err);
  }
};