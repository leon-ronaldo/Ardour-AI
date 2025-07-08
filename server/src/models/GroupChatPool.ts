import mongoose, { Schema, Document } from "mongoose";

export interface IGroupChatMessage {
    from: string;
    message: string;
    timestamp: number;
    groupId: string;
}

export interface IGroupChatParticipant {
    userId: string;
    joinedOn: number;
}

export interface IGroupChatPool extends Document {
    groupId: string; // Unique group ID
    name: string;    // Group name
    participants: IGroupChatParticipant[]; // List of user IDs
    messages: IGroupChatMessage[];
    createdOn: number;
}

const GroupChatMessageSchema = new Schema<IGroupChatMessage>({
    from: { type: String, required: true },
    message: { type: String, required: true },
    timestamp: { type: Number, required: true }
});

const GroupChatPoolSchema = new Schema<IGroupChatPool>({
    groupId: { type: String, required: true, unique: true },
    name: { type: String, required: true },
    participants: {
        type: [String],
        required: true,
        validate: [(val: string[]) => val.length >= 2, "Group must have at least 2 participants"]
    },
    messages: [GroupChatMessageSchema],
    createdOn: { type: Number, default: () => Date.now() }
});

const GroupChatPool = mongoose.model<IGroupChatPool>("GroupChatPool", GroupChatPoolSchema);

export default GroupChatPool;
