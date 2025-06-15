// models/User.ts
import mongoose, { Document } from "mongoose";
export interface IPassUser {
  userName: string,
  userId: string,
  profileImage?: string
}

export interface PostNotification {
  postId: string,
  timeStamp: number
}

export interface AccountReqNotification {
  userId: string,
  timeStamp: number
}

export interface IPassAccountReqNotification {
  userId: string,
  userName: string,
  profileImage?: string,
  timeStamp: number;
}

export interface IUserNotification {
  postNotifications: PostNotification[];
  accountReqNotifications: AccountReqNotification[];
}

export interface IUser extends Document {
  _id: mongoose.Types.ObjectId,
  username: string;
  firstName?: string;
  lastName?: string;
  email: string;
  image?: string;
  friendRequests: mongoose.Types.ObjectId[];
  contacts: mongoose.Types.ObjectId[];
  notifications: IUserNotification;
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
  notifications: {
    type: {
      postNotifications: {
        type: [
          {
            postId: { type: String, required: true },
            timeStamp: { type: Number, required: true },
          }
        ],
        default: [],
      },
      accountReqNotifications: {
        type: [
          {
            userId: { type: String, required: true },
            timeStamp: { type: Number, required: true },
          }
        ],
        default: [],
      },
    },
    default: () => ({ postNotifications: [], accountReqNotifications: [] }),
  },
  createdOn: { type: Date, default: Date.now }
});

const UserModel = mongoose.model<IUser>("User", UserSchema);
export default UserModel;
