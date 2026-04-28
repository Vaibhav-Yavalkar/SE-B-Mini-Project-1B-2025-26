export interface User {
  id: string;
  name: string;
  initials: string;
  role: "student" | "professor";
  verified: boolean;
  joinDate: string;
  itemsPosted: number;
  itemsReturned: number;
}

export interface Item {
  id: string;
  type: "lost" | "found";
  title: string;
  description: string;
  category: string;
  brand: string;
  building: string;
  floor: string;
  image: string;
  ownerId: string;
  ownerName: string;
  ownerInitials: string;
  status: "active" | "returned";
  createdAt: string;
  timeAgo: string;
}

export interface Conversation {
  id: string;
  contactName: string;
  contactInitials: string;
  contactColor: string;
  itemTag: string;
  lastMessage: string;
  timestamp: string;
  unread: number;
  online: boolean;
}

export interface ChatMessage {
  id: string;
  senderId: string;
  text: string;
  timestamp: string;
  isMe: boolean;
}
