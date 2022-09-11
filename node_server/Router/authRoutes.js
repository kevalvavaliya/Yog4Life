const express = require("express");
const AuthController = require("../controllers/AuthController");
const authRouter = express.Router();

// register user
authRouter.post("/register", async (req, res) => {
	return AuthController.registerUser(req, res);
});

authRouter.post("/otp/verify", (req, res) => {
	return AuthController.verifyOtp(req, res);
});

authRouter.get("/login", (req, res) => {
	return AuthController.loginUser(req, res);
});

authRouter.post("/logout", (req, res) => {
	return AuthController.logout(req, res);
});

module.exports = authRouter;
