const asyncHandler = require("express-async-handler");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/UserModel");

const registerUser = asyncHandler(async (req, res) => {
  const { userName, email, password, phone } = req.body;
  
  if (!userName || !email || !password || !phone) {
    res.status(401).json({message: "All fields are mandatory!"});
    return
  }

  const userExists = await User.findOne({ email }); //email set to primary key, set userName or anything as per your wish
  if (userExists) {
    res.status(400).json({ message: "User already exists try loggin in!" });
    return
  }

  //Hash password
  const hashedPassword = await bcrypt.hash(password, 10);

  const user = await User.create({
    userName: userName,
    email: email,
    password: hashedPassword,
    phone: phone,
  });

  if (user) {
    const accessToken = jwt.sign(
      { userId: user._id, email: user.email }, 'your secret here', { expiresIn: '1d' } //consider adding secret via .env file
    );

    const refreshToken = jwt.sign(
        { userId: user._id, email: user.email }, 'your different secret here', { expiresIn: '7d' } //consider adding secret via .env file
    );

    res.status(201).json({accessToken: accessToken, refreshToken: refreshToken})
  } else {
    res.status(501).json({message: "Some error occured while creating user, try again!"});
  }
});

const loginUser = asyncHandler(async (req, res) => {
  const { email, password } = req.body; //email login, change to userName or anything as per your wish

  if (!email || !password) {
    res.status(401).json({message: "All fields are mandatory!"})
    return
  }

  const user = await User.findOne({ email: email });

  if (!user) {
    res.status(404).json({message: "No user found try creating one!"});
    return
  }

  //compare password with hashedpassword
  if (user && (await bcrypt.compare(password, user.password))) {

    const accessToken = jwt.sign(
      { userId: user._id, email: user.email }, 'your secret here', { expiresIn: '1d' } //consider adding secret via .env file
    );

    const refreshToken = jwt.sign(
      { userId: user._id, email: user.email }, 'your different secret here', { expiresIn: '7d' } //consider adding secret via .env file
    );

    res.status(200).json({accessToken: accessToken, refreshToken: refreshToken})
  } else {
    res.status(401).json({message: 'incorrect credentials'});
  }
});

const googleLogin = asyncHandler(async (req, res) => {
  const { email } = req.body; //email login, change to userName or anything as per your wish

  if (!email) {
    res.status(401).json({ message: "All fields are mandatory!" })
    return
  }

  let user = await User.findOne({ email: email });

  if (!user) {
    user = await User.create(req.body)

    if (!user) {
      res.status(501).json({ error: "internal server error try again" });
      return
    };
  }

  const accessToken = jwt.sign(
    { userId: user._id, email: user.email }, 'your secret here', { expiresIn: '1d' } //consider adding secret via .env file
  );

  const refreshToken = jwt.sign(
    { userId: user._id, email: user.email }, 'your different secret here', { expiresIn: '7d' } //consider adding secret via .env file
  );

  res.status(200).json({ accessToken: accessToken, refreshToken: refreshToken, _id: user._id })
});

const currentUser = asyncHandler(async (req, res) => {
  const user = await User.findById(req.user.userId);

  if (!user) {
    return res.status(404).json({ message: "User not found" });
  }

  res.status(200).json({ message: 'user success', 'user': user });
});

module.exports = { registerUser, loginUser, currentUser, googleLogin }
