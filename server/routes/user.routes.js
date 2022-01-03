const express = require("express");
const User = require("../models/user.models");
const config = require("../config");
const jwt = require("jsonwebtoken");
const router = express.Router();

const validateToken = require('../validate')

router.route("/:username").get(validateToken,(req, res) => {
  User.findOne({ username: req.params.username }, (err, user) => {
    if (err) return res.status(500).json({ message: err });
    return res.json({
      data: user,
      username: req.params.username,
    });
  });
});

router.route("/login").post((req, res) => {
  User.findOne({ username: req.body.username }, (err, user) => {
    if (err) return res.status(500).json({ message: err });
    if (!user) return res.status(404).json({ message: "User not found" });
    if (user.password !== req.body.password)
      return res.status(401).json({ message: "Invalid password" });
    const token = jwt.sign({ username: req.body.username }, config.key, {
      expiresIn: "24h",
    });
    return res.json({
      data: user,
      token,
    });
  });
});

router.route("/register").post((req, res) => {
  const user = new User(req.body);
  user
    .save()
    .then(() => {
      res.status(201).json({ message: "User created successfully" });
    })
    .catch((err) => {
      res.json({ message: err });
    });
});

router.route("/update/:username").patch(validateToken,(req, res) => {
  User.findOneAndUpdate(
    { username: req.params.username },
    { $set: { password: req.body.password } },
    { new: true },
    (err, user) => {
      if (err) {
        res.status(500).json({ message: err });
      } else {
        res.json({ message: "Password updated successfully" });
      }
    }
  );
});

router.route("/delete/:username").delete(validateToken,(req, res) => {
  User.findOneAndDelete({ username: req.params.username }, (err, user) => {
    if (err) {
      res.status(500).json({ message: err });
    } else {
      res.json({ message: "User deleted successfully" });
    }
  });
});

module.exports = router;
