const mongoose = require("mongoose"),
	Schema = mongoose.Schema;

const postSchema = new Schema(
	{
		author: {
			type: mongoose.Types.ObjectId,
			required: true,
			ref: "users",
		},
		description: {
			type: String,
			required: true,
		},
		image: {
			type: String,
			required: false,
			default: "",
		},
		date: {
			type: Date,
			required: true,
		},
	},
	{
		timestamps: true,
		versionKey: false,
		collection: "posts",
		strictPopulate: false,
	},
);

const PostsModel = mongoose.model("posts", postSchema);
module.exports = PostsModel;
