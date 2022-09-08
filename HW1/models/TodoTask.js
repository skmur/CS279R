const mongoose = require('mongoose');
// make collection schema
const todoTaskSchema = new mongoose.Schema({
    content: {
        type: String,
        required: true
    },
    date: {
        type: Date,
        default: Date.now
    }
})
// export it to use in index.js file
module.exports = mongoose.model('TodoTask',todoTaskSchema);