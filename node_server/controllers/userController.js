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

	editProfile: async (req, res) => {
		// edit user profile
		try {
			let user = await UsersModel.findOne({
				_id: req.user.id,
			});

			if (!user) {
				return res.status(400).json({
					message: "User not found",
					data: null,
				});
			}

			if (req.body.username) {
				user.username = req.body.username;
			}

			if (req.body.email) {
				user.email = req.body.email;
			}

			if (req.body.bio) {
				user.bio = req.body.bio;
			}

			if (req.body.profile_pic) {
				user.profile_pic = req.body.profile_pic;
			}

			user = await user.save();

			user.otp = "";

			let users_blogs = await PostsModel.find({
				author: req.user.id,
			}).populate("author", ["username", "profile_pic"]);

			return res.status(200).json({
				message: "User profile updated successfully",
				data: { user, users_blogs },
			});
		} catch (error) {
			return res.status(500).json({
				message: "Internal server error",
				error: error.message,
			});
		}
	},
};
