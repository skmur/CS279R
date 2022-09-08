// username: soniamurthy
// password: hviQo9bdxVC5h6Wa

// require previously installed dependencies
const express = require("express");
const app = express();
// require file connecting to database
const dotenv = require("dotenv");
const mongoose = require("mongoose");

// require TodoTask model
const TodoTask = require("./models/TodoTask");

dotenv.config();

// serve static files in a directory named "public"
app.use("/static", express.static("public"))

// Urlencoded allows us to extract the data from the form by adding her to the body property of the request.
app.use(express.urlencoded({ extended: true }));

// // commented out to avoid Error: `useFindAndModify` is an invalid option.
// mongoose.set("useFindAndModify", false);

//connection to db
mongoose.connect(process.env.DB_CONNECT, { useNewUrlParser: true }, () => {
    console.log("Connected to db!");
    // replaced our app.listen so our server would only run after the connection is made
    app.listen(3000, () => console.log("Server Up and running"));
});

// view engine configuration; assigns the setting name "view engine" to value "ejs"
app.set("view engine", "ejs");

// GET method: read the data from the database so when we enter the page or when 
// we add a new item we can see it at our app
app.get("/", (req, res) => {
    TodoTask.find({}, (err, tasks) => {
        res.render("todo.ejs", { todoTasks: tasks });
    });
});

// POST method: clicking add button inserts data to database
app.post('/',async (req, res) => {
    const todoTask = new TodoTask({
        content: req.body.content
    });
    try {
        await todoTask.save();
        res.redirect("/");
    } catch (err) {
        res.redirect("/");
    }
});

//UPDATE
app.route("/edit/:id").get((req, res) => {
    // find our id
    const id = req.params.id;
    TodoTask.find({}, (err, tasks) => {
        //  render the new template
        res.render("todoEdit.ejs", { todoTasks: tasks, idTask: id });
    });
}).post((req, res) => {
    const id = req.params.id;
    // update our task using the mongoose method findByIdAndUpdate
    TodoTask.findByIdAndUpdate(id, { content: req.body.content }, err => {
        if (err) return res.send(500, err);
        res.redirect("/");
    });
});

//DELETE
app.route("/remove/:id").get((req, res) => {
    const id = req.params.id;
    // delete our task using the mongoose method findByIdAndRemove
    TodoTask.findByIdAndRemove(id, err => {
        if (err) return res.send(500, err);
        res.redirect("/");
    });
});