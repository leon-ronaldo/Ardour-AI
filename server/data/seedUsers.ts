// scripts/seedUsers.ts
import mongoose from "mongoose";
import UserModel, { IUser } from "../models/User";
import { generateAccessToken } from "../middleware/authMiddleware";

const MONGO_URI = "mongodb://localhost:27017/Ardour-AI";

const rawUsers = [
  { username: "john_doe", firstName: "John", lastName: "Doe", email: "john.doe@example.com" },
  { username: "jane_smith", firstName: "Jane", lastName: "Smith", email: "jane.smith@example.com" },
  { username: "robert_lee", firstName: "Robert", lastName: "Lee", email: "robert.lee@example.com" },
  { username: "alice_wang", firstName: "Alice", lastName: "Wang", email: "alice.wang@example.com" },
  { username: "michael_kim", firstName: "Michael", lastName: "Kim", email: "michael.kim@example.com" },
  { username: "lisa_chen", firstName: "Lisa", lastName: "Chen", email: "lisa.chen@example.com" }
];

const contactMap: Record<string, string[]> = {
  "john_doe": ["jane_smith", "robert_lee", "alice_wang"],
  "jane_smith": ["john_doe", "robert_lee"],
  "robert_lee": ["john_doe", "jane_smith", "michael_kim"],
  "alice_wang": ["john_doe"],
  "michael_kim": ["robert_lee", "lisa_chen"],
  "lisa_chen": ["michael_kim", "jane_smith"]
};

const seedUsers = async () => {
  try {
    await mongoose.connect(MONGO_URI);
    console.log("🚀 Connected to MongoDB");

    await UserModel.deleteMany({});
    console.log("🧹 Cleared existing users");

    const insertedUsers: IUser[] = await UserModel.insertMany(rawUsers);
    console.log("✅ Inserted users");

    const usernameToId = new Map<string, mongoose.Types.ObjectId>();
    insertedUsers.forEach((user) => {
      usernameToId.set(user.username, user._id as mongoose.Types.ObjectId);
    });

    for (const user of insertedUsers) {
      const contactUsernames = contactMap[user.username] || [];
      const contactIds = contactUsernames
        .map((name) => usernameToId.get(name))
        .filter((id): id is mongoose.Types.ObjectId => !!id);

      await UserModel.findByIdAndUpdate(user._id, { contacts: contactIds });
    }

    console.log("✅ Updated contacts for each user");
  } catch (error) {
    console.error("❌ Seeding error:", error);
  } finally {
    await mongoose.disconnect();
    console.log("🔌 Disconnected from MongoDB");
  }
};

// seedUsers();
// console.log
//   (generateAccessToken("68413302ed9412ec5c0af366", "jane.smith@example.com"))
