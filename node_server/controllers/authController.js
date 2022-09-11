const UsersSessionModel = require("../models/usersSessionModel");
const sendSMS = require("../services/twillio");
const TokenManager = require("../middlewares/TokenManager");
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
	verifyOtp: async (req, res) => {
		try {
			console.log("verify otp");
			let { mobileNumber, otp } = req.body;

			if (!mobileNumber || !otp) {
				return res.status(400).json({
					message: "Please fill all the fields",
				});
			}

			let user = await UsersModel.findOneAndUpdate(
				{
					mobileNumber,
					otp,
				},
				{
					$set: { is_verified: true },
				},
				{ new: true },
			);

			if (user) {
				// generate jwt token
				let token = TokenManager.generateToken({
					id: user._id,
					username: user.username,
					mobileNumber: user.mobileNumber,
				});

				let user_session = await new UsersSessionModel({
					user_id: user._id,
					token,
				}).save();

				return res.status(200).json({
					message: "OTP verified successfully",
					data: {
						token,
						user_id: user._id,
						username: user.username,
						mobileNumber: user.mobileNumber,
					},
				});
			} else {
				return res.status(400).json({
					message: "Invalid OTP",
					data: null,
				});
			}
		} catch (error) {
			return res.status(500).json({
				message: "Internal server error",
				error: error.message,
			});
		}
	},
	loginUser: async (req, res) => {
		console.log("login user");
		try {
			let { mobileNumber } = req.body;

			if (!mobileNumber) {
				return res.status(400).json({
					message: "Please fill all the fields",
				});
			}

			let user = await UsersModel.findOne({
				mobileNumber,
			});

			if (user) {
				// generate jwt token
				let token = TokenManager.generateToken({
					id: user._id,
					username: user.username,
					mobileNumber: user.mobileNumber,
				});

				return res.status(200).json({
					message: "User logged in successfully",
					data: {
						token,
					},
				});
			} else {
				return res.status(400).json({
					message: "User not found",
				});
			}
		} catch (error) {
			return res.status(500).json({
				message: "Internal server error",
				error: error.message,
			});
		}
	},

	logout: async (req, res) => {
		try {
			// find user session
			let userSession = await UsersSessionModel.findOne({
				token: req.body.token,
			});

			if (!userSession) {
				return res.status(400).json({
					message: "User Session not found!",
					data: null,
				});
			} else {
				let deletedSession = await UsersSessionModel.findOneAndDelete({
					token: req.body.token,
				});

				return res.status(200).json({
					message: "User Session has been logged out!",
					data: null,
				});
			}
		} catch (error) {
			return res.status(500).json({
				message: "Internal Server Error!",
				error: error.message,
			});
		}
	},
};
