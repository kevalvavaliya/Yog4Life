const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");
const UsersSessionModel = require("../models/usersSessionModel");
const UsersModel = require("../models/usersModel");

module.exports = {
	generateToken: function (user) {
		return jwt.sign(
			user,
			process.env.JWT_SECRET,
			// 	, {
			// 	expiresIn: config.tokenLife,
			// }
		);
	},
};
