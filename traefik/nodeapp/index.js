import express from "express";

const app = express();

app.set('trust proxy', true);


app.get("/", (req, res) => {
    res.send("Hello World! | app");
}); 

app.listen(3000, "0.0.0.0", () => {
    console.log("Server is running on port 3000");
});
