import mongoose from "mongoose";
import ChatPool from "../models/ChatPool";

const MONGO_URI = "mongodb://localhost:27017/Ardour-AI";

async function fetchMessages(participant1Id: string, participant2Id: string, participant1Handle: string, participant2Handle: string
) {
    await mongoose.connect(MONGO_URI);
    console.log("🚀 Connected to MongoDB");

    const pool = await ChatPool.findOne({
        participants: { $all: [participant1Id, participant2Id] }
    });

    if (!pool) {
        console.log("😔 noo chat pools found");
        return;
    }

    for (var message of pool.messages)
        console.log(message.from === participant1Id ? `${participant1Handle}:` : `${participant2Handle}:`, message.message);
}

fetchMessages("684ae745794f47ec213bbf68", "684b0ab50e2c9ca1d99925c0", "AI", "User");