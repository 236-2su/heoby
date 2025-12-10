export function SummarySkeleton() {
  const placeholders = ["total", "unread", "emergency", "warning"];

  return (
    <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
      {placeholders.map((placeholder) => (
        <div
          key={placeholder}
          className="h-24 rounded-2xl bg-gray-100 animate-pulse"
        />
      ))}
    </div>
  );
}
