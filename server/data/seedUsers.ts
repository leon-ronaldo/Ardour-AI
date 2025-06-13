// scripts/seedUsers.ts
import mongoose from "mongoose";
import UserModel, { IUser } from "../models/User";
import { generateAccessToken } from "../middleware/authMiddleware";

const MONGO_URI = "mongodb://localhost:27017/Ardour-AI";

const rawUsers = [
  { username: "manish_brainwave", firstName: "Manish", lastName: "Prasad", email: "manish.prasad@example.com" },
  { username: "soorya_mix", firstName: "Sooryodhaya", lastName: "", email: "soorya@example.com" },
  { username: "baba_yaga", firstName: "John", lastName: "Wick", email: "john.wick@example.com" },
  { username: "gothams_richest", firstName: "Ben", lastName: "Affleck", email: "ben.affleck@example.com" },
  { username: "lucia_legend", firstName: "Lucia", lastName: "Caminos", email: "lucia.caminos@example.com" },
  { username: "ashlyn_daily", firstName: "Ashlyn", lastName: "Mary", email: "ashlyn.mary@example.com" },
  { username: "mike_ls", firstName: "Michael", lastName: "De Santa", email: "michael.desanta@example.com" },
  { username: "sam_frost", firstName: "Samantha", lastName: "Gallen", email: "samantha.gallen@example.com" },
  { username: "vaas_loop", firstName: "Vaas", lastName: "Montenegro", email: "vaas.m@example.com" },
  { username: "captain_kenway", firstName: "Edward", lastName: "Kenway", email: "edward.kenway@example.com" },
  { username: "faith_bliss", firstName: "Faith", lastName: "Seed", email: "faith.seed@example.com" },
  { username: "ezio_firenze", firstName: "Ezio", lastName: "Auditore", email: "ezio.auditore@example.com" },

  // original 6 users
  { username: "john_doe", firstName: "John", lastName: "Doe", email: "john.doe@example.com", },
  { username: "jane_smith", firstName: "Jane", lastName: "Smith", email: "jane.smith@example.com", },
  { username: "robert_lee", firstName: "Robert", lastName: "Lee", email: "robert.lee@example.com", },
  { username: "alice_wang", firstName: "Alice", lastName: "Wang", email: "alice.wang@example.com", },
  { username: "michael_kim", firstName: "Michael", lastName: "Kim", email: "michael.kim@example.com", },
  { username: "lisa_chen", firstName: "Lisa", lastName: "Chen", email: "lisa.chen@example.com", },
];

const contactMap: Record<string, string[]> = {
  // original users
  "john_doe": ["jane_smith", "robert_lee", "alice_wang"],
  "jane_smith": ["john_doe", "robert_lee"],
  "robert_lee": ["john_doe", "jane_smith", "michael_kim"],
  "alice_wang": ["john_doe"],
  "michael_kim": ["robert_lee", "lisa_chen"],
  "lisa_chen": ["michael_kim", "jane_smith"],

  // new sample users
  "manish_brainwave": ["soorya_mix", "baba_yaga", "lucia_legend"],
  "soorya_mix": ["manish_brainwave", "ashlyn_daily"],
  "baba_yaga": ["gothams_richest", "ezio_firenze", "captain_kenway"],
  "gothams_richest": ["baba_yaga", "mike_ls"],
  "lucia_legend": ["faith_bliss", "vaas_loop"],
  "ashlyn_daily": ["soorya_mix", "sam_frost"],
  "mike_ls": ["gothams_richest", "sam_frost"],
  "sam_frost": ["ashlyn_daily", "mike_ls"],
  "vaas_loop": ["lucia_legend", "faith_bliss"],
  "captain_kenway": ["ezio_firenze", "baba_yaga"],
  "faith_bliss": ["lucia_legend", "vaas_loop"],
  "ezio_firenze": ["captain_kenway", "baba_yaga"],
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

seedUsers();
// console.log
//   (generateAccessToken("68413302ed9412ec5c0af366", "jane.smith@example.com"))
