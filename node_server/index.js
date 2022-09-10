require("dotenv").config();
const express = require("express");
const http = require("http");
const morgan = require("morgan");
const parser = require("body-parser");
const authRouter = require("./Router/authRoutes");

const app = express();

const server = http.createServer(app);

let node_env = process.env.NODE_ENV || "local";

const mongo_url =
	node_env === "local" ? process.env.MONGO_URL : process.env.MONGO_LIVE;

mongoose.connect(
	mongo_url,
	{
		useNewUrlParser: true,
		useUnifiedTopology: true,
	},
	(d) => {
		if (d) console.log(`ERROR CONNECTING TO DB ${mongo_url}`, d);
		console.log(
			`Connected to ${process.env.NODE_ENV} database: `,
			`${mongo_url}`,
		);
	},
);

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

app.use("/auth", authRouter);

app.listen(process.env.PORT, () => {
	console.log(`server up and running on port ${process.env.PORT}`);
});
