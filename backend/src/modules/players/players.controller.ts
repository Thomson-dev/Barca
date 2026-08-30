import { Request, Response, NextFunction } from 'express';
import playersService from './players.service';

export const list = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const result = await playersService.list();
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

export const getById = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const result = await playersService.getById(req.params.id);
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

export const create = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const result = await playersService.create(req.body);
    res.status(201).json(result);
  } catch (err) {
    next(err);
  }
};

export const update = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const result = await playersService.update(req.params.id, req.body);
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

export const remove = async (req: Request, res: Response, next: NextFunction) => {
  try {
    await playersService.remove(req.params.id);
    res.status(204).send();
  } catch (err) {
    next(err);
  }
};