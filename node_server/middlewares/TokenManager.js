const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");
const UsersSessionModel = require("../models/usersSessionModel");
const UsersModel = require("../models/usersModel");

module.exports = {
	decodeToken: async function (req, res, next) {
		const bearerHeader = req.headers["authorization"];
		if (typeof bearerHeader !== "undefined") {
			// Split at the space
			const bearerToken = bearerHeader.split(" ")[1];
			try {
				// decode token
				const decoded = jwt.decode(bearerToken);
				req.user = decoded;

				if (!decoded) {
					return res.status(400).json({
						message: "Invalid token",
					});
				}

				// check if user session is exists
				const session = await UsersSessionModel.findOne({
					token: bearerToken,
					user_id: mongoose.Types.ObjectId(req.user.id),
				});

				if (!session || session.length === 0) {
					return res.status(401).json({
						message: "Session is expired please login again!",
					});
				}

				next();
			} catch (err) {
				return res.status(401).json({
					message: "Unauthorised! Access denied",
				});
			}
		} else {
			return res.status(401).json({
				message: "Token Not Provided!",
			});
		}
	},

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
