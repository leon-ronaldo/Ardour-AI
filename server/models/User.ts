// models/User.ts
import mongoose, { Document } from "mongoose";

export interface IUser extends Document {
  _id: mongoose.Types.ObjectId,
  username: string;
  firstName?: string;
  lastName?: string;
  email: string;
  image?: string;
  friendRequests: mongoose.Types.ObjectId[];
  contacts: mongoose.Types.ObjectId[];
  createdOn: Date;
}

const UserSchema = new mongoose.Schema<IUser>({
  username: { type: String, required: true, unique: true },
  firstName: { type: String },
  lastName: { type: String },
  image: { type: String },
  email: { type: String, required: true, unique: true },
  contacts: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
  friendRequests: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
  createdOn: { type: Date, default: Date.now }
});

const UserModel = mongoose.model<IUser>("User", UserSchema);
export default UserModel;
