import { MapPin } from "lucide-react";
import BottomNav from "@/components/BottomNav";
import { items } from "@/data/mock-data";

const MapScreen = () => {
  return (
    <div className="min-h-screen bg-background pb-24">
      <div className="px-5 pt-6 mb-4">
        <h1 className="text-2xl font-bold text-foreground">Campus Map</h1>
        <p className="text-sm text-muted-foreground">Items reported across campus</p>
      </div>

      {/* Map placeholder */}
      <div className="mx-5 bg-secondary rounded-2xl h-64 relative overflow-hidden flex items-center justify-center">
        <div className="text-center">
          <MapPin className="w-10 h-10 text-primary mx-auto mb-2" />
          <p className="text-sm text-muted-foreground">Interactive map coming soon</p>
          <p className="text-xs text-muted-foreground mt-1">University of Tech • Main Campus</p>
        </div>
        {/* Decorative pins */}
        {[
          { top: "20%", left: "30%" },
          { top: "40%", left: "60%" },
          { top: "60%", left: "25%" },
          { top: "35%", left: "75%" },
          { top: "70%", left: "55%" },
        ].map((pos, i) => (
          <div
            key={i}
            className="absolute w-6 h-6 rounded-full bg-primary/30 flex items-center justify-center animate-pulse"
            style={pos}
          >
            <div className="w-2.5 h-2.5 rounded-full bg-primary" />
          </div>
        ))}
      </div>

      {/* Nearby items */}
      <div className="px-5 mt-6">
        <h2 className="font-bold text-foreground mb-3">Nearby Reports</h2>
        <div className="space-y-3">
          {items.slice(0, 4).map((item) => (
            <div key={item.id} className="flex items-center gap-3 bg-card rounded-xl p-3 border border-border/50">
              <img src={item.image} alt={item.title} className="w-14 h-14 rounded-lg object-cover" />
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2">
                  <span className={`text-[10px] font-bold uppercase ${item.type === "lost" ? "text-lost" : "text-found"}`}>
                    {item.type}
                  </span>
                  <span className="text-xs text-muted-foreground">{item.timeAgo}</span>
                </div>
                <p className="font-medium text-foreground text-sm truncate">{item.title}</p>
                <p className="text-xs text-muted-foreground flex items-center gap-1">
                  <MapPin className="w-3 h-3 text-primary" />
                  {item.building}
                </p>
              </div>
            </div>
          ))}
        </div>
      </div>

      <BottomNav />
    </div>
  );
};

export default MapScreen;
