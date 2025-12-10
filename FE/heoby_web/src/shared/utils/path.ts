const normalizeBasePath = (basePath: string) => {
  if (!basePath) return "/";
  const trimmed = basePath.endsWith("/") && basePath !== "/" ? basePath.slice(0, -1) : basePath;
  return trimmed.startsWith("/") ? trimmed : `/${trimmed}`;
};

const normalizePath = (path: string) => {
  if (!path) return "/";
  return path.startsWith("/") ? path : `/${path}`;
};

/**
 * 앱 베이스 경로를 고려해 라우터 경로를 생성합니다.
 * includeBase가 true이면 실제 브라우저 경로(베이스 포함)를 반환하고,
 * false이면 Router 내부에서 사용할 경로(/부터 시작)를 반환합니다.
 */
export const buildAppPath = (path: string, options?: { includeBase?: boolean }) => {
  const basePathEnv = import.meta.env.VITE_BASE_PATH ?? "/";
  const basePath = normalizeBasePath(basePathEnv);
  const normalizedPath = normalizePath(path);

  if (!options?.includeBase || basePath === "/") {
    return normalizedPath;
  }

  return `${basePath}${normalizedPath === "/" ? "" : normalizedPath}`;
};
