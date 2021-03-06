const express = require("express");

const app = express();
const port = 3034;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const routes = require("./routes");

app.use("/api", routes);

app.listen(port, () => console.log(`Listening on port ${port}`));
module.exports = app;
