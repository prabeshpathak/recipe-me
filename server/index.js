const express = require("express");
const mongooose = require("mongoose");

mongooose.connect("mongodb://localhost/restful_blog_app");
const PORT = process.env.PORT || 8000;

const app = express();
app.route("/").get((req, res) => {
  return res.json({ message: "hi" });
});

app.listen(PORT, () => console.log(`server started on ${PORT}`));
