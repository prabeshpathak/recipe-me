const jwt = require("jsonwebtoken");
const config = require("./config");

const validateToken = (req, res, next) => {
  let token = req.headers["authorization"];
  token = token.slice(7, token.length);
  if (!token) {
    return res.status(401).json({ message: "No token provided" });
  }
  jwt.verify(token, config.key, (err, decoded) => {
    if (err) {
      return res.status(401).json({ message: "Invalid token", status: false });
    }
    req.userId = decoded.userId;
    next();
  });
};

module.exports = validateToken;
