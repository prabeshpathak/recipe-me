const cors = require("cors");
const express = require("express");
const mongoose = require("mongoose");

// Load the environmental variables before anything requires them
require("dotenv").config();

// Create the running app object for the api
const app = express();

// Add middleware at to the app that will be applied to every endpoint
app.use(cors());
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use("/images", express.static("uploads"));

// Retrieve MongoDB configuration from the .env
const MONGO_URI = process.env.MONGO_URL;

// Initialize logging for API requests
const logger = require("./routes/lib/logging");
logger.httpLogging(app);

// Apply the Express router object to the app. This only serves content from the /api path
// This path employs an authenticated and an unauthenticated route
const { router, authenticatedRouter } = require("./routes/index");
app.use("/api", router);
app.use("/api", authenticatedRouter);

// Capture error messages generated by API requests
logger.errorLogging(app);

// Begin our connection to the configured database
mongoose
  .connect(MONGO_URI, {
    useNewUrlParser: true,
    useFindAndModify: false,
    useUnifiedTopology: true,
    useCreateIndex: true,
  })
  .then(() => {
    console.log("Mongoose Connection Successful");
  })
  .catch(function (error) {
    // If we fail to connect, we should exit the app, as the database is vital to all operations
    console.log("Mongoose Connection Error : " + error);
    // Note: process.exit is bad practice and an alternative should be found
    process.exit(1);
  });

// Log database connection failures after the initial connection
mongoose.connection.on("error", function (error) {
  // Going to utilize a logging library for this and other errors
  console.log("Mongoose Connection Error : Connection Lost :  " + error);
});

// Retrieve the port to use, or 3001 if one is not in the environment
const PORT = process.env.PORT || 3001;

// Check for the SSL environmental variables, so we know whether or not we are going to be serving https
if (process.env.SSL == 1) {
  const https = require("https");
  const fs = require("fs");
  const httpsServer = https.createServer(
    {
      key: fs.readFileSync(process.env.CERT_KEY_LOCATION),
      cert: fs.readFileSync(process.env.CERT_LOCATION),
    },
    app
  );

  httpsServer.listen(PORT, function () {
    console.log(`Server listening on port ${PORT}.`);
  });
} else {
  app.listen(PORT, function () {
    console.log(`Server listening on port ${PORT}.`);
  });
}
