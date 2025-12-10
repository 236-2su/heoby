// interface MockFallbackParams<T> {
//   label: string;
//   action: () => Promise<T>;
//   fallback: () => T | Promise<T>;
// }

// export async function withMockFallback<T>({
//   label,
//   action,
//   fallback,
// }: MockFallbackParams<T>): Promise<T> {
//   try {
//     return await action();
//   } catch (error) {
//     console.warn(`[mock:${label}] 실제 API 호출 실패, mock 데이터로 대체합니다.`, error);
//     return await fallback();
//   }
// }
