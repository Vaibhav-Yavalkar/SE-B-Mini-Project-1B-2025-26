import { useNavigate } from "react-router-dom";
import { ArrowRight, Camera, Bell, MessageSquare, Shield } from "lucide-react";

const WelcomeScreen = () => {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen flex flex-col bg-background">
      {/* Hero */}
      <div className="relative h-[45vh] overflow-hidden">
        <img
          src="/images/campus-hero.jpg"
          alt="Campus at dusk"
          className="w-full h-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-b from-background/30 via-background/60 to-background" />
        <div className="absolute top-6 left-5">
          <h2 className="text-foreground font-bold text-lg tracking-wide">CampusTrace</h2>
        </div>
        <div className="absolute bottom-8 left-5 right-5">
          <span className="inline-block bg-lost/80 text-foreground text-xs font-semibold px-3 py-1 rounded-full mb-3">
            University Enterprise Edition
          </span>
          <h1 className="text-4xl font-extrabold text-foreground leading-tight">
            Lost it? Found it.
            <br />
            <span className="text-primary">Trace it.</span>
          </h1>
          <p className="text-muted-foreground mt-2 text-sm max-w-xs">
            The official secure network for recovered campus property.
          </p>
        </div>
      </div>

      {/* How it works */}
      <div className="flex-1 px-5 py-6">
        <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider mb-4">How it works</h3>
        <div className="space-y-4">
          {[
            { icon: Camera, title: "Post an Entry", desc: "Snap a photo of a found item or describe what you've lost in seconds." },
            { icon: Bell, title: "Smart Notifications", desc: "Instant alerts when a potential match is reported nearby." },
            { icon: MessageSquare, title: "Secure Verification", desc: "Chat directly with finders to verify ownership via secure campus auth." },
          ].map((item) => (
            <div key={item.title} className="flex items-start gap-3">
              <div className="w-10 h-10 rounded-xl bg-secondary flex items-center justify-center shrink-0">
                <item.icon className="w-5 h-5 text-primary" />
              </div>
              <div>
                <h4 className="font-semibold text-foreground text-sm">{item.title}</h4>
                <p className="text-xs text-muted-foreground leading-relaxed">{item.desc}</p>
              </div>
            </div>
          ))}
        </div>

        {/* Stats */}
        <div className="flex gap-3 mt-6 bg-secondary rounded-2xl p-4">
          <div className="flex-1 text-center">
            <div className="text-2xl font-bold text-foreground">1.2k+</div>
            <div className="text-xs text-muted-foreground">Items Returned</div>
          </div>
          <div className="w-px bg-border" />
          <div className="flex-1 text-center">
            <div className="text-2xl font-bold text-foreground">15 min</div>
            <div className="text-xs text-muted-foreground">Avg. Match Time</div>
          </div>
        </div>

        {/* CTAs */}
        <div className="mt-6 space-y-3">
          <button
            onClick={() => navigate("/login")}
            className="w-full bg-primary text-primary-foreground py-4 rounded-2xl font-semibold flex items-center justify-center gap-2 hover:opacity-90 transition-opacity"
          >
            Get Started with SSO
            <ArrowRight className="w-4 h-4" />
          </button>
          <button
            onClick={() => navigate("/home")}
            className="w-full border border-border text-foreground py-4 rounded-2xl font-semibold hover:bg-secondary transition-colors"
          >
            Browse Public Gallery
          </button>
        </div>

        <p className="text-center text-xs text-muted-foreground mt-4 flex items-center justify-center gap-1">
          <Shield className="w-3 h-3" />
          By continuing, you agree to the Campus Safety Protocols
        </p>
      </div>
    </div>
  );
};

export default WelcomeScreen;
