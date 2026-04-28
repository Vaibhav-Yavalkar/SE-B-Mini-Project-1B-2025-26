import { useNavigate } from "react-router-dom";
import { LogOut, CheckCircle, Package, RotateCcw, Calendar, ChevronRight, Settings, HelpCircle, Shield } from "lucide-react";
import BottomNav from "@/components/BottomNav";
import { currentUser } from "@/data/mock-data";

const ProfileScreen = () => {
  const navigate = useNavigate();

  const stats = [
    { icon: Package, label: "Items Posted", value: currentUser.itemsPosted },
    { icon: RotateCcw, label: "Items Returned", value: currentUser.itemsReturned },
    { icon: Calendar, label: "Joined", value: currentUser.joinDate },
  ];

  const menuItems = [
    { label: "Settings", icon: Settings },
    { label: "Help & Support", icon: HelpCircle },
    { label: "Privacy Policy", icon: Shield },
  ];

  return (
    <div className="min-h-screen bg-background pb-24">
      <div className="px-5 pt-6">
        <h1 className="text-2xl font-bold text-foreground mb-6">Profile</h1>

        <div className="flex items-center gap-4 mb-6">
          <div className="w-16 h-16 rounded-full bg-primary/20 flex items-center justify-center text-xl font-bold text-primary">
            {currentUser.initials}
          </div>
          <div>
            <div className="flex items-center gap-2">
              <h2 className="text-lg font-bold text-foreground">{currentUser.name}</h2>
              {currentUser.verified && <CheckCircle className="w-4 h-4 text-primary" />}
            </div>
            <p className="text-sm text-muted-foreground capitalize">{currentUser.role} • Verified</p>
          </div>
        </div>

        <div className="grid grid-cols-3 gap-3 mb-6">
          {stats.map((s) => (
            <div key={s.label} className="bg-card rounded-xl p-3 text-center border border-border/50">
              <s.icon className="w-5 h-5 text-primary mx-auto mb-1" />
              <p className="text-lg font-bold text-foreground">{s.value}</p>
              <p className="text-[10px] text-muted-foreground">{s.label}</p>
            </div>
          ))}
        </div>

        <div className="space-y-1">
          {menuItems.map((m) => (
            <button key={m.label} className="w-full flex items-center gap-3 px-4 py-3.5 rounded-xl hover:bg-secondary transition-colors">
              <m.icon className="w-5 h-5 text-muted-foreground" />
              <span className="flex-1 text-left text-sm font-medium text-foreground">{m.label}</span>
              <ChevronRight className="w-4 h-4 text-muted-foreground" />
            </button>
          ))}
        </div>

        <button
          onClick={() => navigate("/")}
          className="w-full mt-6 flex items-center justify-center gap-2 py-3.5 rounded-xl border border-destructive/30 text-destructive text-sm font-medium hover:bg-destructive/10 transition-colors"
        >
          <LogOut className="w-4 h-4" />
          Sign Out
        </button>
      </div>

      <BottomNav />
    </div>
  );
};

export default ProfileScreen;
