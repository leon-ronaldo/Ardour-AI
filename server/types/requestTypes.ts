import { Request } from "express";

interface AuthRequestUser { userId: string; email: string }

interface AuthRequest extends Request {
    user?: AuthRequestUser;
}

export { AuthRequest, AuthRequestUser }