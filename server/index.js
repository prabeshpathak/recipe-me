const express = require("express");
const app = express();

app.route("/").get((req, res) => {
  return res.json({ message: "hi" });
});

app.listen(5000, () => console.log("server started"));
