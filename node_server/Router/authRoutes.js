const express = require("express");
const AuthController = require("../controllers/AuthController");
const authRouter = express.Router();

// register user
authRouter.post("/register", async (req, res) => {
	return AuthController.registerUser(req, res);
});

module.exports = authRouter;
