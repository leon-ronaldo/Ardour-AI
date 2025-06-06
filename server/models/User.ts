// models/User.ts
import mongoose, { Document } from "mongoose";

export interface IUser extends Document {
  _id: mongoose.Types.ObjectId,
  username: string;
  firstName: string;
  lastName: string;
  email: string;
  contacts: mongoose.Types.ObjectId[];
  createdOn: Date;
  isAuthorized(): boolean;
}

const UserSchema = new mongoose.Schema<IUser>({
  username: { type: String, required: true, unique: true },
  firstName: { type: String, required: true },
  lastName: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  contacts: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
  createdOn: { type: Date, default: Date.now }
});

UserSchema.methods.isAuthorized = function (): boolean {
  return true;
};

const UserModel = mongoose.model<IUser>("User", UserSchema);
export default UserModel;
