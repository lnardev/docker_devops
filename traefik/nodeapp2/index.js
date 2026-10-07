import express from "express";

const app = express();

app.set('trust proxy', true);

app.get("/", (req, res) => {
    res.send("Hello World! | app2");
}); 

app.listen(3001, "0.0.0.0", () => {
    console.log("Server is running on port 3000");
});
