const express = require("express");
const userController = require("../controllers/userController");
const TokenManager = require("../middlewares/TokenManager");

const userRouter = express.Router();

userRouter.post("/profile", TokenManager.decodeToken, (req, res) => {
	return userController.getProfile(req, res);
});

module.exports = userRouter;
