import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Search, Bell, Plus } from "lucide-react";
import ItemCard from "@/components/ItemCard";
import StatCard from "@/components/StatCard";
import BottomNav from "@/components/BottomNav";
import { useItems } from "@/context/ItemsContext";
import { cn } from "@/lib/utils";

const filters = ["All Items", "Lost", "Found", "Electronics", "Books", "IDs"];

const HomeScreen = () => {
  const navigate = useNavigate();
  const { items } = useItems();
  const [activeFilter, setActiveFilter] = useState("All Items");
  const [searchQuery, setSearchQuery] = useState("");

  const filteredItems = items.filter((item) => {
    const matchesSearch = item.title.toLowerCase().includes(searchQuery.toLowerCase());
    if (activeFilter === "All Items") return matchesSearch;
    if (activeFilter === "Lost") return item.type === "lost" && matchesSearch;
    if (activeFilter === "Found") return item.type === "found" && matchesSearch;
    return item.category === activeFilter && matchesSearch;
  });

  return (
    <div className="min-h-screen bg-background pb-24">
      <div className="px-5 pt-6 pb-2">
        <div className="flex items-center justify-between mb-1">
          <div>
            <h1 className="text-xl font-bold text-foreground">CampusTrace</h1>
            <p className="text-xs text-muted-foreground">University of Tech • Main Campus</p>
          </div>
          <div className="flex items-center gap-3">
            <button className="relative">
              <Bell className="w-5 h-5 text-muted-foreground" />
              <span className="absolute -top-1 -right-1 w-2 h-2 bg-primary rounded-full" />
            </button>
          </div>
        </div>

        <div className="flex items-center bg-secondary rounded-xl px-4 py-3 gap-2 mt-4">
          <Search className="w-4 h-4 text-muted-foreground" />
          <input
            type="text"
            placeholder="Search for lost keys, IDs, electronics..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="bg-transparent text-foreground placeholder:text-muted-foreground flex-1 outline-none text-sm"
          />
        </div>

        <div className="flex gap-2 mt-4 overflow-x-auto scrollbar-hide -mx-5 px-5">
          {filters.map((f) => (
            <button
              key={f}
              onClick={() => setActiveFilter(f)}
              className={cn(
                "px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-colors border",
                activeFilter === f
                  ? "bg-primary/15 border-primary text-primary"
                  : "bg-secondary border-transparent text-muted-foreground"
              )}
            >
              {f}
            </button>
          ))}
        </div>

        <div className="flex gap-2 mt-4">
          <StatCard value={items.filter(i => i.status === "active").length} label="Active Posts" />
          <StatCard value={items.filter(i => i.status === "returned").length} label="Returned" highlight />
          <StatCard value={items.filter(i => i.timeAgo === "Just now").length} label="New Today" />
        </div>
      </div>

      <div className="px-5 mt-4">
        <div className="flex items-center justify-between mb-3">
          <h2 className="font-bold text-foreground">Recently Reported</h2>
          <button className="text-sm text-primary font-medium" onClick={() => navigate("/map")}>See Map</button>
        </div>
        <div className="space-y-4">
          {filteredItems.map((item, i) => (
            <div key={item.id} style={{ animationDelay: `${i * 80}ms` }}>
              <ItemCard item={item} />
            </div>
          ))}
        </div>
      </div>

      <button
        onClick={() => navigate("/report")}
        className="fixed bottom-24 right-5 w-14 h-14 bg-primary rounded-full flex items-center justify-center shadow-lg shadow-primary/30 z-40 hover:scale-105 transition-transform"
      >
        <Plus className="w-6 h-6 text-primary-foreground" />
      </button>

      <BottomNav />
    </div>
  );
};

export default HomeScreen;
