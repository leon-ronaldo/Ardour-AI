import jwt, { JwtPayload } from "jsonwebtoken";

const generateAccessToken = (_id: string, email: string) => jwt.sign(
    { _id, email }, process.env.JWT_SECRET as string, { expiresIn: '1d' }
);

const generateRefreshToken = (_id: string, email: string) => jwt.sign(
    { _id, email }, process.env.JWT_REFRESH_SECRET as string, { expiresIn: '7d' }
);

const authenticateJWT = (token: string): { valid: boolean; expired: boolean; decoded?: { _id: string, email: string }; error?: string } => {
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET as string) as { _id: string, email: string };
        return { valid: true, expired: false, decoded };
    } catch (err: any) {
        if (err.name === "TokenExpiredError") {
            return { valid: false, expired: true, error: "Token expired" };
        } else if (err.name === "JsonWebTokenError") {
            return { valid: false, expired: false, error: "Invalid token" };
        } else {
            return { valid: false, expired: false, error: "Token verification failed" };
        }
    }
};

export { authenticateJWT, generateAccessToken, generateRefreshToken };