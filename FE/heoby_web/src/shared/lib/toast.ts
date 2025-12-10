import toast from "react-hot-toast";

const buildToastId = (type: string, message: string) =>
  `${type}:${message ?? ""}`;

export const showErrorToast = (message: string) =>
  toast.error(message, { id: buildToastId("error", message) });

export const showSuccessToast = (message: string) =>
  toast.success(message, { id: buildToastId("success", message) });
