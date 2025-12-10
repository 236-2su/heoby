export const USER_ROLE = {
  USER: "주민",
  LEADER: "이장",
} as const;

export type USERROLE = keyof typeof USER_ROLE;

export interface UserState {
  userUuid: string | null;
  villageId: number | null;
  username: string | null;
  email: string | null;
  role: USERROLE | null;
}

interface UserActions {
  setUser: (user: UserState) => void;
  clearUser: () => void;
}

export type UserStore = UserState & UserActions;
