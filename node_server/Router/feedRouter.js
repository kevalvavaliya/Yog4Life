const express = require("express");
const TokenManager = require("../middlewares/TokenManager");
const FeedController = require("../controllers/feedController");
const upload = require("../middlewares/upload");
const feedRouter = express.Router();

// create post
feedRouter.post("/post/create", TokenManager.decodeToken, async (req, res) => {
	return FeedController.createPost(req, res);
});

// edit post
feedRouter.put("/post/:id", TokenManager.decodeToken, async (req, res) => {
	return FeedController.editPost(req, res);
});

// get all post
feedRouter.post("/posts", TokenManager.decodeToken, async (req, res) => {
	return FeedController.getAllPosts(req, res);
});

// delete all post
feedRouter.delete("/post/:id", TokenManager.decodeToken, async (req, res) => {
	return FeedController.deletePost(req, res);
});

module.exports = feedRouter;
