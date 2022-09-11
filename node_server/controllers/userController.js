const PostsModel = require("../models/postModel");
const UsersModel = require("../models/usersModel");

module.exports = {
	getProfile: async (req, res) => {
		try {
			// get user profile
			// do not fetch otp
			let user = await UsersModel.findOne({
				_id: req.user.id,
			}).select("-otp");

			let users_blogs = await PostsModel.find({
				author: req.user.id,
			}).populate("author", ["username", "profile_pic"]);

			if (!user) {
				return res.status(400).json({
					message: "User not found",
					data: null,
				});
			}

			return res.status(200).json({
				message: "User profile fetched successfully",
				data: {
					user,
					users_blogs,
				},
			});
		} catch (error) {
			return res.status(500).json({
				message: "Internal server error",
				error: error.message,
			});
		}
	},

	getProfileById: async (req, res) => {
		try {
			// get user profile
			let user = await UsersModel.findOne({
				_id: req.params.id,
			}).select("-otp");

			if (!user) {
				return res.status(400).json({
					message: "User not found",
					data: null,
				});
			}

			let users_blogs = await PostsModel.find({
				author: req.params.id,
			}).populate("author", ["username", "profile_pic"]);

			return res.status(200).json({
				message: "User profile fetched successfully",
				data: {
					user,
					users_blogs,
				},
			});
		} catch (error) {
			return res.status(500).json({
				message: "Internal server error",
				error: error.message,
			});
		}
	},
};
