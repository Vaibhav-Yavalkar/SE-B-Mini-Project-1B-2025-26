import { useParams, useNavigate } from "react-router-dom";
import { ArrowLeft, MoreVertical, MapPin, MessageSquare, Share2, Bookmark, CheckCircle, Layers, Tag, Building, DoorOpen } from "lucide-react";
import StatusBadge from "@/components/StatusBadge";
import { items } from "@/data/mock-data";
import { toast } from "sonner";

const ItemDetailScreen = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const item = items.find((i) => i.id === id);

  if (!item) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <p className="text-muted-foreground">Item not found</p>
      </div>
    );
  }

  const details = [
    { icon: Layers, label: "CATEGORY", value: item.category },
    { icon: Tag, label: "BRAND", value: item.brand },
    { icon: Building, label: "BUILDING", value: item.building },
    { icon: DoorOpen, label: "FLOOR/ROOM", value: item.floor },
  ];

  return (
    <div className="min-h-screen bg-background pb-8">
      {/* Header */}
      <div className="flex items-center justify-between px-4 py-3 sticky top-0 bg-background/90 backdrop-blur z-10">
        <button onClick={() => navigate(-1)} className="w-9 h-9 rounded-full bg-secondary flex items-center justify-center">
          <ArrowLeft className="w-5 h-5 text-foreground" />
        </button>
        <h2 className="font-semibold text-foreground">Item Details</h2>
        <button className="w-9 h-9 rounded-full bg-secondary flex items-center justify-center">
          <MoreVertical className="w-5 h-5 text-foreground" />
        </button>
      </div>

      {/* Image */}
      <div className="relative mx-4 rounded-2xl overflow-hidden h-56">
        <img src={item.image} alt={item.title} className="w-full h-full object-cover" />
        <div className="absolute bottom-3 left-3">
          <StatusBadge type={item.type} />
        </div>
      </div>

      {/* Title */}
      <div className="px-5 mt-4 flex items-start justify-between">
        <div>
          <h1 className="text-2xl font-bold text-foreground">{item.title}</h1>
          <p className="text-sm text-muted-foreground mt-1 flex items-center gap-1">
            <MapPin className="w-3.5 h-3.5 text-primary" />
            Posted {item.timeAgo} • {item.building}
          </p>
        </div>
        <button className="text-muted-foreground">
          <Bookmark className="w-5 h-5" />
        </button>
      </div>

      {/* Details grid */}
      <div className="grid grid-cols-2 gap-3 px-5 mt-5">
        {details.map((d) => (
          <div key={d.label} className="bg-secondary rounded-xl p-3">
            <d.icon className="w-5 h-5 text-primary mb-2" />
            <p className="text-[10px] text-muted-foreground uppercase tracking-wider">{d.label}</p>
            <p className="text-sm font-semibold text-foreground">{d.value}</p>
          </div>
        ))}
      </div>

      {/* Description */}
      <div className="px-5 mt-5">
        <h3 className="font-semibold text-foreground mb-2">Description</h3>
        <p className="text-sm text-muted-foreground leading-relaxed">{item.description}</p>
      </div>

      {/* Map placeholder */}
      <div className="px-5 mt-5">
        <h3 className="font-semibold text-foreground mb-2">Last Seen Location</h3>
        <div className="bg-secondary rounded-2xl h-40 flex items-center justify-center">
          <div className="text-center">
            <MapPin className="w-8 h-8 text-primary mx-auto mb-1" />
            <p className="text-xs text-muted-foreground">{item.building}</p>
          </div>
        </div>
      </div>

      {/* Owner */}
      <div className="px-5 mt-5">
        <h3 className="font-semibold text-foreground mb-2">Posted by</h3>
        <div className="flex items-center gap-3 bg-secondary rounded-xl p-3">
          <div className="w-10 h-10 rounded-full bg-card flex items-center justify-center text-sm font-semibold text-foreground">
            {item.ownerInitials}
          </div>
          <div className="flex-1">
            <p className="font-semibold text-foreground text-sm">{item.ownerName}</p>
            <p className="text-xs text-muted-foreground">Student • Verified</p>
          </div>
          <CheckCircle className="w-5 h-5 text-primary" />
        </div>
      </div>

      {/* Actions */}
      <div className="flex gap-3 px-5 mt-6">
        <button
          onClick={() => navigate("/messages")}
          className="flex-1 bg-primary text-primary-foreground py-3.5 rounded-2xl font-semibold flex items-center justify-center gap-2 text-sm"
        >
          <MessageSquare className="w-4 h-4" />
          Message
        </button>
        <button
          onClick={() => toast.success("Link copied!")}
          className="w-14 bg-secondary rounded-2xl flex items-center justify-center"
        >
          <Share2 className="w-5 h-5 text-foreground" />
        </button>
      </div>
    </div>
  );
};

export default ItemDetailScreen;
