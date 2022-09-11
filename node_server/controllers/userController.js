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
			});

			return res.status(200).json({
				message: "User profile fetched successfully",
				data: {
					user,
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
