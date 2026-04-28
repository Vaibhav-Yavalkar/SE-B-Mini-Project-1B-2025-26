import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { AtSign, Lock, Shield } from "lucide-react";

const LoginScreen = () => {
  const navigate = useNavigate();
  const [tab, setTab] = useState<"signin" | "register">("signin");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    navigate("/home");
  };

  return (
    <div className="min-h-screen flex flex-col items-center justify-center px-6 bg-background">
      <div className="w-16 h-16 rounded-2xl bg-secondary flex items-center justify-center mb-4">
        <div className="w-8 h-8 border-2 border-primary rounded-full flex items-center justify-center">
          <div className="w-2 h-2 bg-primary rounded-full" />
        </div>
      </div>
      <h1 className="text-3xl font-bold text-foreground mb-1">CampusTrace</h1>
      <p className="text-sm text-muted-foreground mb-8">Enterprise Lost & Found for Universities</p>

      {/* Tabs */}
      <div className="flex bg-secondary rounded-xl p-1 w-full max-w-sm mb-6">
        {(["signin", "register"] as const).map((t) => (
          <button
            key={t}
            onClick={() => setTab(t)}
            className={`flex-1 py-2.5 rounded-lg text-sm font-medium transition-colors ${
              tab === t ? "bg-card text-foreground" : "text-muted-foreground"
            }`}
          >
            {t === "signin" ? "Sign In" : "Register"}
          </button>
        ))}
      </div>

      <form onSubmit={handleSubmit} className="w-full max-w-sm space-y-4">
        <div>
          <label className="text-xs font-semibold uppercase tracking-wider text-muted-foreground mb-1.5 block">
            Campus Email
          </label>
          <div className="flex items-center bg-secondary rounded-xl px-4 py-3 gap-3">
            <AtSign className="w-5 h-5 text-muted-foreground" />
            <input
              type="email"
              placeholder="student@university.edu"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="bg-transparent text-foreground placeholder:text-muted-foreground flex-1 outline-none text-sm"
            />
          </div>
        </div>

        <div>
          <label className="text-xs font-semibold uppercase tracking-wider text-muted-foreground mb-1.5 block">
            Password
          </label>
          <div className="flex items-center bg-secondary rounded-xl px-4 py-3 gap-3">
            <Lock className="w-5 h-5 text-muted-foreground" />
            <input
              type="password"
              placeholder="••••••••••"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="bg-transparent text-foreground placeholder:text-muted-foreground flex-1 outline-none text-sm"
            />
          </div>
          <button type="button" className="text-primary text-sm mt-2 w-full text-center">
            Forgot Password?
          </button>
        </div>

        <button
          type="submit"
          className="w-full bg-foreground text-background py-4 rounded-2xl font-semibold text-sm hover:opacity-90 transition-opacity"
        >
          Sign into CampusTrace
        </button>
      </form>

      <div className="flex items-center gap-3 my-6 w-full max-w-sm">
        <div className="flex-1 h-px bg-border" />
        <span className="text-xs text-muted-foreground uppercase">or continue with</span>
        <div className="flex-1 h-px bg-border" />
      </div>

      <div className="flex gap-3 w-full max-w-sm">
        <button className="flex-1 bg-secondary py-3 rounded-xl text-sm font-medium text-foreground">Google</button>
        <button className="flex-1 bg-secondary py-3 rounded-xl text-sm font-medium text-foreground">Apple</button>
      </div>

      <div className="mt-8 bg-primary/10 rounded-xl p-4 w-full max-w-sm">
        <p className="text-xs text-primary flex items-start gap-2">
          <Shield className="w-4 h-4 shrink-0 mt-0.5" />
          Use your official university credentials to enable automated campus verification.
        </p>
      </div>

      <p className="text-sm text-muted-foreground mt-6">
        New to the platform?{" "}
        <button className="text-foreground font-semibold" onClick={() => setTab("register")}>
          Create Account
        </button>
      </p>
    </div>
  );
};

export default LoginScreen;
