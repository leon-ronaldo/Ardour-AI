import mongoose from 'mongoose'

const connectDb = async () => {
    try {
        const connection = await mongoose.connect("mongodb://localhost:27017");
        console.log(
            "Database connected: ",
            connection.connection.host,
            connection.connection.name
        );
    } catch (err) {
        console.error(err);
    }
};

export default connectDb