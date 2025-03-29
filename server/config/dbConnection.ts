import mongoose from 'mongoose'

const connectDb = async () => {
    try {
    const connection = await mongoose.connect("mongodb srv string here!!");
    console.log(
        "Database connected: ",
        connect.connection.host,
        connect.connection.name
    );
    } catch (err) {
    console.error(err);
    }
};

export default connectDb