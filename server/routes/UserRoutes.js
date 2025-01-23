const express = require("express");
const router = express.Router();
const {
  loginUser,
  registerUser,
  currentUser,
} = require("../controllers/UserController");


const ensureAuthenticated = require("../middleware/authMiddleware");

router.route("/current").get(ensureAuthenticated, currentUser);
router.route("/login").post(loginUser);
router.route("/register").post(registerUser);

module.exports = router;