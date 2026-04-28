import { cn } from "@/lib/utils";

interface StatusBadgeProps {
  type: "lost" | "found";
  className?: string;
}

const StatusBadge = ({ type, className }: StatusBadgeProps) => (
  <span
    className={cn(
      "px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider",
      type === "lost"
        ? "bg-lost/20 text-lost"
        : "bg-found/20 text-found",
      className
    )}
  >
    {type}
  </span>
);

export default StatusBadge;
