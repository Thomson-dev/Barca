class AuthService {
  async register(data: unknown) {
    throw new Error('Not implemented');
  }

  async login(data: unknown) {
    throw new Error('Not implemented');
  }

  async refresh(refreshToken: string) {
    throw new Error('Not implemented');
  }

  async logout(userId: string) {
    throw new Error('Not implemented');
  }
}

export default new AuthService();
