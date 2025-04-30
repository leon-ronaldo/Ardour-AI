import { Request } from "express";
import WebSocket from "ws";

interface AuthRequestUser { userId: string; email: string }

interface AuthRequest extends Request {
    user?: AuthRequestUser;
}

interface WSUser extends WebSocket {
    id: string;
    userName: string;
}

export { AuthRequest, AuthRequestUser, WSUser }