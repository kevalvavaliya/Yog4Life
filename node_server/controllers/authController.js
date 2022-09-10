const UsersModel = require("../models/usersModel");
module.exports = {
	registerUser: async (req, res) => {
		try {
			console.log("Register user");
			let { username, mobileNumber, isRegister } = req.body;
			console.log(req.body);
			// register user
			if (!username || !mobileNumber) {
				return res.status(400).json({
					message: "Please fill all the fields",
				});
			}

			// check if user already exists with same mobile number or not
			let user = await UsersModel.findOne({
				mobileNumber,
				is_verified: true,
			});

			if (user) {
				// user already exists with same mobileNumber
				return res.status(409).json({
					message:
						"user already exists with given mobile number please try login!",
					data: null,
				});
			}

			user = await new UsersModel({
				username: username ? username : random.first(),
				mobileNumber,
				otp,
			}).save();
			return res.status(200).json({
				message: "OTP sent successfully",
				data: {
					otp,
				},
			});
		} catch (error) {
			return res.status(500).json({
				message: "Internal server error",
				error: error,
			});
		}
	},
};
