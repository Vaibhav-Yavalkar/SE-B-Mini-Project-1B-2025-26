import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { ItemsProvider } from "@/context/ItemsContext";
import WelcomeScreen from "./pages/WelcomeScreen";
import LoginScreen from "./pages/LoginScreen";
import HomeScreen from "./pages/HomeScreen";
import ItemDetailScreen from "./pages/ItemDetailScreen";
import ReportItemScreen from "./pages/ReportItemScreen";
import MessagesScreen from "./pages/MessagesScreen";
import ChatScreen from "./pages/ChatScreen";
import MapScreen from "./pages/MapScreen";
import ProfileScreen from "./pages/ProfileScreen";
import NotFound from "./pages/NotFound";

const queryClient = new QueryClient();

const App = () => (
  <QueryClientProvider client={queryClient}>
    <TooltipProvider>
      <ItemsProvider>
        <Toaster />
        <Sonner />
        <BrowserRouter>
          <div className="max-w-md mx-auto min-h-screen bg-background relative">
            <Routes>
              <Route path="/" element={<WelcomeScreen />} />
              <Route path="/login" element={<LoginScreen />} />
              <Route path="/home" element={<HomeScreen />} />
              <Route path="/item/:id" element={<ItemDetailScreen />} />
              <Route path="/report" element={<ReportItemScreen />} />
              <Route path="/messages" element={<MessagesScreen />} />
              <Route path="/chat/:id" element={<ChatScreen />} />
              <Route path="/map" element={<MapScreen />} />
              <Route path="/profile" element={<ProfileScreen />} />
              <Route path="*" element={<NotFound />} />
            </Routes>
          </div>
        </BrowserRouter>
      </ItemsProvider>
    </TooltipProvider>
  </QueryClientProvider>
);

export default App;
