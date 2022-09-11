const express = require("express");
const TokenManager = require("../middlewares/TokenManager");

const FeedController = require("../controllers/feedController");

const feedRouter = express.Router();

feedRouter.post("/post/create", TokenManager.decodeToken, async (req, res) => {
	return FeedController.createPost(req, res);
});

feedRouter.post("/posts", TokenManager.decodeToken, async (req, res) => {
	return FeedController.getAllPosts(req, res);
});

module.exports = feedRouter;
