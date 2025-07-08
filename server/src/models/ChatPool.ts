import mongoose, { Schema, Document } from "mongoose";
import crypto from "crypto";
import { IPassUser } from "./User";

export interface IChatMessage {
  from: string;
  to: string;
  message: string;
  timestamp: number; // use Date.now() when storing
  _id?: mongoose.Types.ObjectId;
  repliedTo?: mongoose.Types.ObjectId;
  isRead?: boolean;
}

export interface IChatPool extends Document {
  chatId: string; // shared chat ID between two users
  participants: [string, string]; // user IDs (sorted alphabetically for consistency)
  messages: IChatMessage[];
}

export type ContactWithPreview = {
  contact: IPassUser;
  recentMessages?: IChatMessage[]; // only present for top‑5 contacts
};

const ChatMessageSchema = new Schema<IChatMessage>({
  from: { type: String, required: true },
  to: { type: String, required: true },
  message: { type: String, required: true },
  timestamp: { type: Number, required: true },
  _id: { type: mongoose.Types.ObjectId },
  repliedTo: { type: mongoose.Types.ObjectId },
  isRead: { type: Boolean, default: false }
});

const ChatPoolSchema = new Schema<IChatPool>({
  chatId: { type: String, required: true, unique: true },
  participants: {
    type: [String],
    required: true,
    validate: [(val: string[]) => val.length === 2, "Must have exactly 2 participants"],
  },
  messages: [ChatMessageSchema],
});

const ChatPool = mongoose.model<IChatPool>("ChatPool", ChatPoolSchema);


function generateChatId(u1: string, u2: string, t1: string, t2: string): string {
  const [a, b] = [u1, u2].sort();
  const [ta, tb] = [t1, t2].sort();
  const baseHash = crypto.createHash("md5").update(a + b).digest("hex").slice(0, 10);
  const timeBits = (ta + tb).replace(/\D/g, "").slice(-6); // only digits
  return baseHash + timeBits; // 10 + 6 = 16 characters
}

export {
  generateChatId
}
export default ChatPool;
