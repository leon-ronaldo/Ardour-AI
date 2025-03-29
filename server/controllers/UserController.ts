import { Request, Response } from "express";
import asyncHandler from "express-async-handler";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import User from "../models/UserModel";
import { AuthRequest } from "../types/requestTypes";

//@desc Register a user
//@route POST /users/register
//@access public
const registerUser = asyncHandler(async (req: Request, res: Response) => {
    const { userName, email, password, phone } = req.body;

    if (!userName || !email || !password || !phone) {
        res.status(401).json({ message: "All fields are mandatory!" });
        return;
    }

    const userExists = await User.findOne({ email });
    if (userExists) {
        res.status(400).json({ message: "User already exists try logging in!" });
        return;
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await User.create({
        userName: userName,
        email: email,
        password: hashedPassword,
        phone: phone,
    });

    if (user) {
        const accessToken = jwt.sign(
            { userId: user._id, email: user.email }, 'your secret here', { expiresIn: '1d' }
        );

        const refreshToken = jwt.sign(
            { userId: user._id, email: user.email }, 'your different secret here', { expiresIn: '7d' }
        );

        res.status(201).json({ accessToken, refreshToken });
    } else {
        res.status(501).json({ message: "Some error occurred while creating user, try again!" });
    }
});

//@desc Login user
//@route POST /users/login
//@access public
const loginUser = asyncHandler(async (req: Request, res: Response) => {
    const { email, password } = req.body;

    if (!email || !password) {
        res.status(401).json({ message: "All fields are mandatory!" });
        return;
    }

    const user = await User.findOne({ email });

    if (!user) {
        res.status(404).json({ message: "No user found try creating one!" });
        return;
    }

    // Compare password with hashed password
    if (user && (await bcrypt.compare(password, user.password))) {
        const accessToken = jwt.sign(
            { userId: user._id, email: user.email }, 'your secret here', { expiresIn: '1d' }
        );

        const refreshToken = jwt.sign(
            { userId: user._id, email: user.email }, 'your different secret here', { expiresIn: '7d' }
        );

        res.status(200).json({ accessToken, refreshToken });
    } else {
        res.status(401).json({ message: 'Incorrect credentials' });
    }
});

//@desc Current user info
//@route POST /users/current
//@access private
const currentUser = asyncHandler(async (req: AuthRequest, res: Response): Promise<void> => {
    if (!req.user) {
        res.status(401).json({ message: "Unauthorized" });
        return;
    }

    const user = await User.findById(req.user.userId);

    if (!user) {
        res.status(404).json({ message: "User not found" });
        return;
    }

    res.status(200).json({ message: 'User success', user });
});

export { registerUser, loginUser, currentUser };

