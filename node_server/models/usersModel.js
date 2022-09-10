const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const userSchema = new Schema(
	{
		username: {
			type: String,
			required: true,
		},
		mobileNumber: {
			type: String,
			required: true,
			unique: true,
		},
		otp: {
			type: Number,
			required: true,
		},
		profile_pic: {
			type: String,
			required: false,
			default: "",
		},
		token: {
			type: String,
			required: false,
		},
		is_verified: {
			type: Boolean,
			required: true,
			default: false,
		},
		email: {
			type: String,
			required: false,
			default: "",
		},
		bio: {
			type: String,
			required: false,
			default: "",
		},
	},
	{
		timestamps: true,
		versionKey: false,
		collection: "users",
	},
);

const UsersModel = mongoose.model("users", userSchema);
module.exports = UsersModel;
