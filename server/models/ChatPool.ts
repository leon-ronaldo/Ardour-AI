import mongoose, { Schema, Document } from "mongoose";

export interface IChatMessage {
  from: string;
  to: string;
  message: string;
  timestamp: number; // use Date.now() when storing
}

export interface IChatPool extends Document {
  chatId: string; // shared chat ID between two users
  participants: [string, string]; // user IDs (sorted alphabetically for consistency)
  messages: IChatMessage[];
}

const ChatMessageSchema = new Schema<IChatMessage>({
  from: { type: String, required: true },
  to: { type: String, required: true },
  message: { type: String, required: true },
  timestamp: { type: Number, required: true },
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

export default ChatPool;
