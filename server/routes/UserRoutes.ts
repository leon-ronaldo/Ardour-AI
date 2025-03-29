import express from "express";
import { loginUser, registerUser, currentUser } from "../controllers/UserController";
import ensureAuthenticated from "../middleware/authMiddleware";

const router = express.Router();

router.route("/current").get(ensureAuthenticated, currentUser);
router.route("/login").post(loginUser);
router.route("/register").post(registerUser);

export default router;
