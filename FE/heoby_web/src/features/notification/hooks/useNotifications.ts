import { useUserStore } from "@/features/auth";
import { useMutation, useQuery } from "@tanstack/react-query";
import { getNotifications, registerFCM } from "../api/notificationApi";
import type { Notification } from "../types/domain/notification";
import { NotificationMapper } from "../types/dto/notificationDto";

export const NOTIFICATION_KEYS = {
  type: ["notifications"] as const,
  base: () => [...NOTIFICATION_KEYS.type, "base"] as const,
  fcm: () => [...NOTIFICATION_KEYS.type, "FCM"] as const,
};

export const useNotifications = () => {
  const role = useUserStore((s) => s.role);

  const query = useQuery<Notification, Error>({
    queryKey: NOTIFICATION_KEYS.base(),
    queryFn: async () => {
      const res = await getNotifications(role!);

      return NotificationMapper.fromDto(res);
    },
    enabled: !!role,
  });

  return query;
};

type RegisterFcmParams = {
  userUuid: string;
  platform: string;
  token: string;
};

export const useFcmRegister = () => {
  return useMutation<void, Error, RegisterFcmParams>({
    mutationKey: NOTIFICATION_KEYS.fcm(),
    mutationFn: registerFCM,
  });
};
