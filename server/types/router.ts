import WebSocket from "ws"
import { chatRouter } from "../routes/ChatRoutes"

const AppRoutes: { [route: string]: (ws: WebSocket, req: unknown) => void } = {
    chat: chatRouter,
}

export default AppRoutes;