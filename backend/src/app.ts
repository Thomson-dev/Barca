import cors from 'cors';
import express, { Application } from 'express';
import helmet from 'helmet';

import { errorHandler } from './middleware/error.middleware';
import { notFoundHandler } from './middleware/notFound.middleware';

import authRoutes from './modules/auth/auth.routes';
import usersRoutes from './modules/users/users.routes';
import teamsRoutes from './modules/teams/teams.routes';
import playersRoutes from './modules/players/players.routes';
import matchesRoutes from './modules/matches/matches.routes';
import newsRoutes from './modules/news/news.routes';
import videosRoutes from './modules/videos/videos.routes';
import postsRoutes from './modules/posts/posts.routes';
import commentsRoutes from './modules/comments/comments.routes';
import predictionsRoutes from './modules/predictions/predictions.routes';
import ticketsRoutes from './modules/tickets/tickets.routes';
import productsRoutes from './modules/products/products.routes';
import notificationsRoutes from './modules/notifications/notifications.routes';

const app: Application = express();

app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get('/health', (_req, res) => res.status(200).json({ status: 'ok' }));

app.use('/api/auth', authRoutes);
app.use('/api/users', usersRoutes);
app.use('/api/teams', teamsRoutes);
app.use('/api/players', playersRoutes);
app.use('/api/matches', matchesRoutes);
app.use('/api/news', newsRoutes);
app.use('/api/videos', videosRoutes);
app.use('/api/posts', postsRoutes);
app.use('/api/comments', commentsRoutes);
app.use('/api/predictions', predictionsRoutes);
app.use('/api/tickets', ticketsRoutes);
app.use('/api/products', productsRoutes);
app.use('/api/notifications', notificationsRoutes);

app.use(notFoundHandler);
app.use(errorHandler);

export default app;
