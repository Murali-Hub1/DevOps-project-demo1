const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.send("🚀 Node.js app running on AKS via Azure DevOps!");
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`App running on port ${port}`);
});
