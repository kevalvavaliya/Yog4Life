require("dotenv").config();
const express = require("express");
const http = require("http");

const morgan = require("morgan");
const parser = require("body-parser");

const app = express();
const server = http.createServer(app);

morgan.token("host", function (req) {
	return req.hostname;
});

app.use(
	morgan(
		":method :host :url :status :res[content-length] - :response-time ms",
	),
);
app.use(express.json());
app.use(express.static("public"));
app.use(express.urlencoded({ extended: true }));

app.get("/", (req, res) => {
	return res.status(200).json({
		message: "Server Up and Running!!!",
	});
});

app.listen(process.env.PORT, () => {
	console.log(`server up and running on port ${process.env.PORT}`);
});
