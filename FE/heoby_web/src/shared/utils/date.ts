export function getRelativeTime(date: Date | string) {
  const d = new Date(date);
  const diff = (Date.now() - d.getTime()) / 1000;

  if (diff < 60) return `${Math.floor(diff)}초 전`;
  if (diff < 3600) return `${Math.floor(diff / 60)}분 전`;
  if (diff < 86400) return `${Math.floor(diff / 3600)}시간 전`;
  if (diff < 604800) return `${Math.floor(diff / 86400)}일 전`;
  if (diff < 2419200) return `${Math.floor(diff / 604800)}주 전`;
  if (diff < 29030400) return `${Math.floor(diff / 2419200)}개월 전`;
  return `${Math.floor(diff / 29030400)}년 전`;
}
