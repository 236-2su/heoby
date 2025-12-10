import { useAuthStore } from "@/features/auth/store/authStore";
import { useUserStore } from "@/features/auth/store/userStore";
import { useQuery } from "@tanstack/react-query";
import { UserApi } from "../api/userApi";
import { UserMapper } from "../type/dto/user.dto";

export const USER_KEY = {
  type: ["user"] as const,
  get: () => [...USER_KEY.type, "get"] as const,
};

export const useGetUser = () => {
  const accessToken = useAuthStore((state) => state.accessToken);

  return useQuery({
    queryKey: USER_KEY.get(),
    queryFn: async () => {
      const data = await UserApi.getMe();
      useUserStore.getState().setUser(UserMapper.fromDto(data));

      return data;
    },
    enabled: !!accessToken, // 액세스 토큰이 있을 때만 실행
  });
};
