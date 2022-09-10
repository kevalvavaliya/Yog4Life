const sendSMS = require("../services/twillio");
const UsersModel = require("../models/usersModel");
const random = require("random-name");
module.exports = {
	registerUser: async (req, res) => {
		try {
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

			// generate random 4 digit number
			let otp = Math.floor(1000 + Math.random() * 9000);

			const welcomeMessage = `Welcome to Yog4Life! Your verification code is ${otp}`;

			// send otp to mobileNumber using twillio api
			let response = await sendSMS(mobileNumber, welcomeMessage);

			if (response.sid) {
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
			} else {
				return res.status(400).json({
					message: "Something went wrong",
					data: null,
				});
			}
		} catch (error) {
			return res.status(500).json({
				message: "Internal server error",
				error: error,
			});
		}
	},
};
