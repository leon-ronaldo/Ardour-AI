const mongoose = require("mongoose");

const connectDb = async () => {
    try {
    const connect = await mongoose.connect("mongodb srv string here!!");
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