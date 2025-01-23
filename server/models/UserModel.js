const mongoose = require('mongoose');

// Modify your user model here
const userSchema = mongoose.Schema(
  {
    userName: {
        type: String,
        required: [true, 'username is missing'],
    },
    email: {
        type: String,
        required: [true, 'email id is missing'],
    },
    phone: {
        type: String,
        required: [true, 'phone is missing'],
    },
    password: String,
  }, 
  {
    timestamps: true,
  }
);

// Check if the model already exists to prevent redefining
const User = mongoose.models.User || mongoose.model('User', userSchema);

module.exports = User;