module.exports = {
	createPost: async (req, res) => {
		try {
			// collect post information from body
			let { title, description, image } = req.body;

			if (!description || !image) {
				return res.status(400).json({
					message: "Please fill all the fields",
				});
			}

			// create post
			let post = await PostsModel({
				description,
				image,
				author: req.user.id,
				date,
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

	getAllPosts: async (req, res) => {
		try {
			let posts = await PostsModel.find({}).populate("author", [
				"username",
				"profile_pic",
			]);

			return res.status(200).json({
				message: "Posts fetched successfully",
				data: posts,
			});
		} catch (error) {
			return res.status(500).json({
				message: "Internal server error",
				error: error.message,
			});
		}
	},
};
