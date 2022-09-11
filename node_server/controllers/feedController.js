const mongoose = require("mongoose");
const PostsModel = require("../models/postModel");
const UsersModel = require("../models/usersModel");
module.exports = {
	getAllPosts: async (req, res) => {
		try {
			let cat = req.query.cat;
			let params = {};
			if (cat) {
				params = {
					category_id: cat,
				};
			}
			params.status = "published";
			let blogs = await Blogs.find(params);

			if (!blogs || blogs.length === 0) {
				return res
					.status(201)
					.json(Service.response(1, "No Blogs Found.", []));
			}

			return res
				.status(200)
				.json(Service.response(1, "Blogs Found Success.", blogs));
		} catch (error) {
			return res.status(500).json({
				message: "Internal server error",
				error: error.message,
			});
		}
	},

	createPost: async (req, res) => {
		try {
			let myFile = req.file.originalname.split(".");
			let fileType = myFile[myFile.length - 1];

			const params = {
				Bucket: config.awsBucketName,
				Key: `${uuidv4()}.${fileType}`,
				Body: req.file.buffer,
			};
			s3.upload(params, async (error, data) => {
				if (error)
					return res
						.status(500)
						.json(
							Service.response(0, "Something Went Wrong!", error),
						);

				let blog = new Blogs({
					category_id: req.body.category_id,
					image: data.Location,
					image_alt: data.key.split(".")[0],
					title: req.body.title,
					author_id: req.user.user_id,
					content: req.body.content,
					status: req.body.status,
					date: new Date(),
				});
				// author_id: req.user.user_id,

				let newBlog = await blog.save();

				if (!newBlog || newBlog.length === 0)
					return res
						.status(400)
						.json(
							Service.response(
								0,
								"Something Went Wrong While Processing Your Request!",
								null,
							),
						);

				return res
					.status(200)
					.json(
						Service.response(
							1,
							"Blog Published Successfully.",
							newBlog,
						),
					);
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
			let blog_id = req.query.id;
			let blog = await Blogs.findOne({ _id: blog_id });

			if (!blog || blog.length === 0)
				return res
					.status(201)
					.json(Service.response(0, "Blog Not Found!", null));

			if (blog.author_id.toString() !== req.user.user_id)
				return res
					.status(401)
					.json(Service.response(0, "You are not Authorized!", null));

			if (req.file || typeof req.file !== "undefined") {
				let myFile = req.file.originalname.split(".");
				let fileType = myFile[myFile.length - 1];

				const params = {
					Bucket: config.awsBucketName,
					Key: `${uuidv4()}.${fileType}`,
					Body: req.file.buffer,
				};
				s3.upload(params, async (error, data) => {
					if (error)
						return res
							.status(500)
							.json(
								Service.response(
									0,
									"Something Went Wrong!",
									error,
								),
							);
					Blogs.findOneAndUpdate(
						{ _id: blog_id },
						{
							$set: {
								title: req.body.title
									? req.body.title
									: blog.title,
								content: req.body.content
									? req.body.content
									: blog.content,
								status: req.body.status
									? req.body.status
									: blog.status,
								image: data.Location,
								image_alt: req.body.image_alt
									? req.body.image_alt
									: blog.image_alt,
							},
						},
						{ new: true },
						(error, response) => {
							if (error)
								return res
									.status(500)
									.json(
										Service.response(
											0,
											"Something Went Wrong While Processing Your Request!",
											error,
										),
									);

							return res
								.status(200)
								.json(
									Service.response(
										1,
										"Blog Updated Successfully.",
										response,
									),
								);
						},
					);
				});
			}
		} catch (error) {
			return res.status(500).json({
				message: "Internal server error",
				error: error.message,
			});
		}
	},

	deletePost: async (req, res) => {
		try {
			Blogs.findOneAndUpdate(
				blog_id,
				{
					$set: {
						title: req.body.title ? req.body.title : blog.title,
						status: req.body.status ? req.body.status : blog.status,
						content: req.body.content
							? req.body.content
							: blog.content,
						image_alt: blog.image_alt,
						image: blog.image,
					},
				},
				{
					new: true,
				},
				(error, updatedBlog) => {
					console.log({ updatedBlog });
					if (error)
						return res
							.status(500)
							.json(
								Service.response(
									0,
									"Something Went Wrong!",
									error,
								),
							);
					if (!updatedBlog || updatedBlog.length === 0)
						return res
							.status(201)
							.json(
								Service.response(
									0,
									"Something Went Wrong While Processing Your Request!",
									null,
								),
							);

					return res
						.status(200)
						.json(
							Service.response(
								1,
								"Blog Updated Successfully.",
								updatedBlog,
							),
						);
				},
			);
		} catch (error) {
			return res.status(500).json({
				message: "Internal server error",
				error: error.message,
			});
		}
	},
};
