import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { Search, Settings } from "lucide-react";
import BottomNav from "@/components/BottomNav";
import { cn } from "@/lib/utils";

const msgFilters = ["All", "Found Items", "Lost Items", "Archived"];

const MessagesScreen = () => {
  const navigate = useNavigate();
  const [activeFilter, setActiveFilter] = useState("All");
  const [conversations, setConversations] = useState([]);

  // ✅ Load from MongoDB on mount
  useEffect(() => {
    fetch("http://localhost:5000/api/conversations")
      .then(r => r.json())
      .then(setConversations)
      .catch(err => console.error("Failed to load conversations:", err));
  }, []);

  return (
    <div className="min-h-screen bg-background pb-24">
      <div className="px-5 pt-6">
        <div className="flex items-center justify-between mb-4">
          <h1 className="text-2xl font-bold text-foreground">Messages</h1>
          <Settings className="w-5 h-5 text-muted-foreground" />
        </div>

        <div className="flex items-center bg-secondary rounded-xl px-4 py-3 gap-2 mb-4">
          <Search className="w-4 h-4 text-muted-foreground" />
          <input
            placeholder="Search conversations..."
            className="bg-transparent text-foreground placeholder:text-muted-foreground flex-1 outline-none text-sm"
          />
        </div>

        <div className="flex gap-2 overflow-x-auto scrollbar-hide mb-4">
          {msgFilters.map((f) => (
            <button key={f} onClick={() => setActiveFilter(f)}
              className={cn(
                "px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap border transition-colors",
                activeFilter === f
                  ? "bg-primary/15 border-primary text-primary"
                  : "bg-secondary border-transparent text-muted-foreground"
              )}>
              {f}
            </button>
          ))}
        </div>
      </div>

      <div className="divide-y divide-border">
        {conversations.map((conv: any) => (
          <button key={conv.id} onClick={() => navigate(`/chat/${conv.id}`)}
            className="w-full flex items-center gap-3 px-5 py-4 hover:bg-secondary/50 transition-colors text-left">
            <div className="relative">
              <div className="w-12 h-12 rounded-full flex items-center justify-center text-sm font-semibold"
                style={{ backgroundColor: conv.contactColor + "30", color: conv.contactColor }}>
                {conv.contactInitials}
              </div>
              {conv.online && (
                <span className="absolute bottom-0 left-0 w-3 h-3 bg-found rounded-full border-2 border-background" />
              )}
            </div>
            <div className="flex-1 min-w-0">
              <div className="flex items-center justify-between">
                <span className="font-semibold text-foreground text-sm">{conv.contactName}</span>
                <span className="text-xs text-muted-foreground">{conv.timestamp}</span>
              </div>
              <span className="text-xs text-primary/70 font-medium">{conv.itemTag}</span>
              <p className="text-sm text-muted-foreground truncate">{conv.lastMessage}</p>
            </div>
            {conv.unread > 0 && (
              <span className="w-5 h-5 bg-primary rounded-full flex items-center justify-center text-[10px] font-bold text-primary-foreground">
                {conv.unread}
              </span>
            )}
          </button>
        ))}
      </div>

      <BottomNav />
    </div>
  );
};

export default MessagesScreen;