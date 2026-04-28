import { useNavigate } from "react-router-dom";
import { MapPin, MessageSquare } from "lucide-react";
import StatusBadge from "./StatusBadge";
import { Item } from "@/data/types";

const ItemCard = ({ item }: { item: Item }) => {
  const navigate = useNavigate();

  return (
    <div
      className="bg-card rounded-2xl overflow-hidden cursor-pointer animate-fade-in border border-border/50 hover:border-primary/30 transition-colors"
      onClick={() => navigate(`/item/${item.id}`)}
    >
      <div className="relative h-48 overflow-hidden">
        <img
          src={item.image}
          alt={item.title}
          className="w-full h-full object-cover"
          loading="lazy"
        />
        <div className="absolute top-3 right-3">
          <StatusBadge type={item.type} />
        </div>
      </div>
      <div className="p-4">
        <div className="flex items-start justify-between mb-1">
          <h3 className="font-semibold text-foreground text-lg">{item.title}</h3>
          <span className="text-xs text-muted-foreground whitespace-nowrap ml-2">{item.timeAgo}</span>
        </div>
        <div className="flex items-center gap-1 text-muted-foreground text-sm mb-2">
          <MapPin className="w-3.5 h-3.5 text-primary" />
          <span>{item.building}</span>
        </div>
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="w-7 h-7 rounded-full bg-secondary flex items-center justify-center text-xs font-medium text-secondary-foreground">
              {item.ownerInitials}
            </div>
            <span className="text-sm text-muted-foreground">{item.ownerName}</span>
          </div>
          <button
            onClick={(e) => {
              e.stopPropagation();
              navigate("/messages");
            }}
            className="flex items-center gap-1.5 bg-primary/10 text-primary px-3 py-1.5 rounded-full text-sm font-medium hover:bg-primary/20 transition-colors"
          >
            <MessageSquare className="w-3.5 h-3.5" />
            Message
          </button>
        </div>
      </div>
    </div>
  );
};

export default ItemCard;
