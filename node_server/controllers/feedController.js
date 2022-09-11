const mongoose = require("mongoose");
const BlogsModel = require("../models/postModel");
const UsersModel = require("../models/usersModel");
module.exports = {
	getAllPosts: async (req, res) => {
		try {
			let posts = await PostsModel.find({}).populate("author", [
				"username",
				"profile_pic",
			]);
			if (!posts) {
				return res.status(400).json({
					message: "No Posts Found!!",
					data: null,
				});
			}

			return res.status(200).json({
				message: "Posts fetched successfully",
				data: posts,
			});
		} catch (error) {
			return res.status(500).json({
				message: "Internal server error",
			});
		}
	},

	createPost: async (req, res) => {
		try {
			// collect post information from body
			let { description, image } = req.body;

			if (!description || !image) {
				return res.status(400).json({
					message: "Please fill all the fields",
				});
			}

			if (!userId) {
				return res.status(400).json({
					message: "User Not Found!!!",
					data: null,
				});
			}

			// create post
			let post = await PostsModel({
				description: description ? description : "",
				image: image ? image : "",
				author: req.user.id ? req.user.id : "",
				date: new Date(),
			}).save();

			if (!post) {
				return res.status(400).json({
					message: "Something Went Wrong!",
					data: null,
				});
			}

			post = await PostsModel.find({
				_id: mongoose.Types.ObjectId(post._id),
			}).populate("author", ["username", "profile_pic"]);

			return res.status(200).json({
				message: "Post created successfully",
				data: post,
			});
		} catch (error) {
			return res.status(500).json({
				message: "Internal server error",
				error: error.message,
			});
		}
	},

	editPost: async (req, res) => {
		try {
			// collect post information from body
			let { description, image } = req.body;

			// if (!title && !description) {
			// 	return res.status(400).json({
			// 		message: "Please fill all the fields",
			// 	});
			// }

			// find Post by id
			let post = await PostsModel.findById(req.params.id);

			if (!post) {
				return res.status(400).json({
					message: "Post not found",
					data: null,
				});
			}

			if (post.author.toString() != req.user.id) {
				return res.status(400).json({
					message: "You are not authorized to edit this post",
					data: null,
				});
			}

			// edit post
			post = await PostsModel.findOneAndUpdate(
				{
					_id: req.params.id,
				},
				{
					$set: {
						description: description
							? description
							: post.description,
						image: image ? image : post.image,
					},
				},
				{ new: true, upsert: true },
			);

			if (!post) {
				return res.status(400).json({
					message: "Something Went Wrong!",
					data: null,
				});
			}

			return res.status(200).json({
				message: "Post updated successfully",
				data: post,
			});
		} catch (error) {
			return res.status(500).json({
				message: "Internal server error",
				error: error.message,
			});
		}
	},
	deletePost: async (req, res) => {
		try {
			let postId = req.params.id;

			if (!postId) {
				return res.status(400).json({
					message: "Please Provide post id",
					data: null,
				});
			}

			// find Post by id
			let post = await PostsModel.findById(req.params.id);

			if (!post) {
				return res.status(400).json({
					message: "Post not found",
					data: null,
				});
			}

			if (post.author.toString() != req.user.id) {
				return res.status(400).json({
					message: "You are not authorized to delete this post",
					data: null,
				});
			}

			// delete post
			post = await PostsModel.findOneAndDelete({
				_id: req.params.id,
			});

			if (!post) {
				return res.status(400).json({
					message: "Something Went Wrong!",
					data: null,
				});
			}

			return res.status(200).json({
				message: "Post deleted successfully",
				data: post,
			});
		} catch (error) {
			return res.status(500).json({
				message: "Internal server error",
			});
		}
	},
};
