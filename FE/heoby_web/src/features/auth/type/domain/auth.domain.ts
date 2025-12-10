export interface AuthState {
  accessToken: string | null;
  userUuid: string | null;
  isAuthenticated: boolean;
}

interface AuthActions {
  setAuth: (
    accessToken: string,
    refreshToken: string,
    userUuid: string
  ) => void;
  clearAuth: () => void;
}

export type AuthStore = AuthState & AuthActions;
