import ApiClient, { ENDPOINTS } from "@/shared/api/rest";

import type { USERROLE } from "@/features/auth/type/domain/user.domain";
import {
  NotificationMapper,
  type NotificationDto,
} from "../types/dto/notificationDto";

export const getNotifications = async (
  role: USERROLE
): Promise<NotificationDto> => {
  const { data } = await ApiClient.get<NotificationDto>(
    ENDPOINTS.NOTIFICATION[role]
  );

  console.log(data);
  return NotificationMapper.assertRes(data);
};

export const markNotificationAsRead = async (
  alertUuid: string
): Promise<void> => {
  await ApiClient.put(ENDPOINTS.NOTIFICATION.READ(alertUuid));
};

interface RegisterFcmPayload {
  userUuid: string;
  platform: string;
  token: string;
}

export const registerFCM = async ({
  userUuid,
  platform,
  token,
}: RegisterFcmPayload): Promise<void> => {
  await ApiClient.post(ENDPOINTS.FCM.REGISTER, {
    userUuid,
    platform,
    token,
  });
};
