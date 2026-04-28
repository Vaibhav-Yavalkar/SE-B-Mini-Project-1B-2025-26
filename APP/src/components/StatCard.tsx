import { cn } from "@/lib/utils";

interface StatCardProps {
  value: string | number;
  label: string;
  highlight?: boolean;
}

const StatCard = ({ value, label, highlight }: StatCardProps) => (
  <div
    className={cn(
      "flex-1 rounded-lg px-4 py-3 text-center",
      highlight ? "bg-primary/15" : "bg-secondary"
    )}
  >
    <div className={cn("text-2xl font-bold", highlight ? "text-primary" : "text-foreground")}>
      {value}
    </div>
    <div className="text-xs text-muted-foreground">{label}</div>
  </div>
);

export default StatCard;
