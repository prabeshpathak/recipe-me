// Create an instance of the Express Router to be used as middleware for our routes.
const express = require("express");
const jwt = require("./lib/jwtUtils");
const User = require("../models/user");

// Create our two routers
const router = express.Router();
const authenticatedRouter = express.Router();

// Make the authenticated router refresh the JWT for all endpoints
authenticatedRouter.use(async function (req, res, next) {
  if (req.headers.authorization) {
    // Extract the token from the header
    const token = req.headers.authorization.split(" ")[1];
    if (!token) {
      res
        .status(401)
        .json({ error: "The passed authenticaton token is Invalid" });
      return;
    }
    // console.log(token);
    // Check whether or not the JWT is valid in form
    const success = jwt.isValidJWT(token);
    if (!success) {
      res
        .status(401)
        .json({ error: "The passed authenticaton token is invalid" });
      return;
    }

    // If the user is not in the process of verification, ensure that the user is verified
    const { userId } = jwt.verifyJWT(token);
    if (!req.path.includes("/verify")) {
      const user = await User.findById(userId).exec();
      if (!user.verified) {
        res
          .status(401)
          .json({
            error: "Your account must be verified to perform this action",
          });
        return;
      }
    }

    // If the user is logged in, include the userId in the header so future endpoints can get it
    req.headers.userId = userId;
  } else {
    res
      .status(401)
      .json({ error: "You must be logged in to perform this action" });
    return;
  }

  next();
});

// Allow unauthenticated endpoints to also utilize JWTs if the requester is logged in
router.use(function (req, res, next) {
  if (req.headers.authorization) {
    // Extract the token from the header
    const token = req.headers.authorization.split(" ")[1];
    if (!token) {
      next();
      return;
    }

    // Use the token to obtain the userId
    const success = jwt.isValidJWT(token);
    if (!success) {
      next();
      return;
    }

    // If the user is not in the process of verification, ensure that the user is verified
    const { userId } = jwt.verifyJWT(token);

    // If the user is logged in, include the userId in the header so future endpoints can get it
    req.headers.userId = userId;
  }

  next();
});

const login = require("./login");
const register = require("./register");

// Import api endpoints
const apiEndpoints = {
  account: require("./account"),
  ingredients: require("./ingredients"),
  // login: require('./login'),
  recipes: require("./recipes"),
  refresh: require("./refresh"),
  // register: require('./register'),
  upload: require("./upload"),
  users: require("./users"),
};

// Pass the routers to the endpoints, allowing them to use them
for (var endpoint in apiEndpoints) {
  apiEndpoints[endpoint].use(router, authenticatedRouter);
}
login.use(router);
register.use(router);


// Export the router object
module.exports = {
  router: router,
  authenticatedRouter: authenticatedRouter,
};
