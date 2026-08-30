import { NextFunction, Request, Response } from 'express';
import jwt from 'jsonwebtoken';
import { config } from '../config';
import { ApiError } from '../shared/utils/ApiError';
import { AuthenticatedUser } from '../shared/types';

declare global {
  namespace Express {
    interface Request {
      user?: AuthenticatedUser;
    }
  }
}

export const requireAuth = (req: Request, _res: Response, next: NextFunction) => {
  const header = req.headers.authorization;
  const token = header?.startsWith('Bearer ') ? header.slice(7) : undefined;

  if (!token) {
    return next(new ApiError(401, 'Authentication token missing'));
  }

  try {
    req.user = jwt.verify(token, config.jwtSecret) as AuthenticatedUser;
    next();
  } catch {
    next(new ApiError(401, 'Invalid or expired token'));
  }
};
