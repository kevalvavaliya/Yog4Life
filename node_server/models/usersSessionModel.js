const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const usersSessionSchema = new Schema(
	{
		user_id: {
			type: mongoose.Types.ObjectId,
			required: true,
		},
		token: {
			type: String,
			required: true,
		},
	},
	{
		timestamps: true,
		versionKey: false,
		collection: "users_session",
	},
);

const UsersModel = mongoose.model("users_session", usersSessionSchema);
module.exports = UsersModel;
