import mongoose, { Schema, Document } from "mongoose";

    // Define the schema interface
    interface IChat extends Document {
        Chat: string;
    }
    
    // Define the schema
    const ChatSchema = new Schema<IChat>(
        {
            Chat: { type: String, required: true },
        },
        {
            timestamps: true,
        }
    );
    
    // Check if the model already exists to prevent redefining
    const Chat = mongoose.models.Chat || mongoose.model<IChat>("Chat", ChatSchema);
    
    export default Chat;
        