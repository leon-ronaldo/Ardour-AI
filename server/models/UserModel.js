const mongoose = require('mongoose');

const userSchema = mongoose.Schema(
  {
    userName: { type: String, required: true },
    firstName: { type: String, required: true },
    lastName: { type: String, required: true },
    email: { type: String, required: true },
    phone: String,
    password: String,
    contacts: Array,
    profilePic: String,
    chats: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Chat' }],
    isOnline: { type: Boolean, default: false },  // Track user online status
  },
  {
    timestamps: true,
  }
);

const User = mongoose.model('User', userSchema);

module.exports = User;
