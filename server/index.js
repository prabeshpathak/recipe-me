const express = require("express");
const mongooose = require("mongoose");

mongooose.connect(
  "mongodb+srv://notThePrabesh:youknowwhoiam@cluster0.qnwa7.mongodb.net/myFirstDatabase?retryWrites=true&w=majority",
  {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  }
);
const connection = mongooose.connection;

const PORT = process.env.PORT || 8000;

const app = express();
app.use(express.json());

const userRoutes = require("./routes/user.routes");
app.use("/user", userRoutes);

app.route("/").get((req, res) => {
  return res.json({ message: "hi" });
});

connection.once("open", () => {
  console.log("Database Connected");
});

app.listen(PORT, () => console.log(`server started on ${PORT}`));
