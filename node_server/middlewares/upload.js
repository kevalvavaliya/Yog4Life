const AWS = require("aws-sdk");
const multer = require("multer");
const config = require("../config");

const s3 = new AWS.S3({
	accessKeyId: config.awsId,
	secretAccessKey: config.awsSecretId,
});

const storage = multer.memoryStorage({
	destination: function (req, file, callback) {
		callback(null, "");
	},
});

const upload = multer({ storage }).single("image");

module.exports = upload;
