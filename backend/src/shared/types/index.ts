export interface PaginationQuery {
  page?: number;
  limit?: number;
}

export interface AuthenticatedUser {
  id: string;
  email: string;
  role: string;
}
