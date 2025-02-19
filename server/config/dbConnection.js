const mongoose = require("mongoose");

const connectDb = async () => {
    try {
    const connect = await mongoose.connect("mongodb+srv://leonsihub:ronaldo%40mongoDB@test.ta6zz.mongodb.net/?retryWrites=true&w=majority&appName=Test");
    console.log(
        "Database connected: ",
        connect.connection.host,
        connect.connection.name
    );
    } catch (err) {
    console.log(err);
    }
};

module.exports = connectDb;