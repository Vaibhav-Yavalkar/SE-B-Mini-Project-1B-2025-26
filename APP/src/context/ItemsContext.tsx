import { createContext, useContext, useState, useEffect, ReactNode } from "react";
import { Item } from "@/data/types";

const API = "http://localhost:5000/api/items";

interface ItemsContextType {
  items: Item[];
  addItem: (item: Item) => Promise<void>;
  deleteItem: (id: string) => Promise<void>;
}

const ItemsContext = createContext<ItemsContextType | undefined>(undefined);

export const ItemsProvider = ({ children }: { children: ReactNode }) => {
  const [items, setItems] = useState<Item[]>([]);

  useEffect(() => {
    fetch(API)
      .then(r => r.json())
      .then(setItems)
      .catch(err => console.error("Failed to load items:", err));
  }, []);

  const addItem = async (item: Item) => {
    const res = await fetch(API, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(item),
    });
    const saved = await res.json();
    setItems(prev => [saved, ...prev]);
  };

  const deleteItem = async (id: string) => {
    await fetch(`${API}/${id}`, { method: "DELETE" });
    setItems(prev => prev.filter(i => i.id !== id));
  };

  return (
    <ItemsContext.Provider value={{ items, addItem, deleteItem }}>
      {children}
    </ItemsContext.Provider>
  );
};

export const useItems = () => {
  const ctx = useContext(ItemsContext);
  if (!ctx) throw new Error("useItems must be used within ItemsProvider");
  return ctx;
};