import WebSocket from "ws";
import { ErrorCodes, SuccessCodes } from "./responseCodes";
import { IUser } from "../models/User";

class WebSocketResponder {
  public user: IUser | undefined;
  constructor(private ws: WebSocket, user?: IUser) { }

  setUser(user: IUser) {
    this.user = user;
  }

  send(data: any) {
    this.ws.send(JSON.stringify(data));
  }

  sendError(message: string) {
    this.send({ error: message });
  }

  sendMessage(payload: any) {
    this.send({ message: payload });
  }

  sendData(payload: any) {
    this.send({ data: payload });
  }

  invalidParametersError() {
    this.sendError("Invalid parameters passed");
  }

  sendMessageFromCode(code: number) {
    const allCodes = { ...ErrorCodes, ...SuccessCodes };
    const message =
      Object.entries(allCodes).find(([, val]) => val === code)?.[0] ?? "Unknown Code";

    this.send({
      message,
      code,
    });
  }

  closeClient(): void;
  closeClient(code: number, message?: string): void;
  closeClient(message: string): void;
  closeClient(codeOrMessage?: number | string, maybeMessage?: string): void {
    if (typeof codeOrMessage === "number") {
      const code = codeOrMessage;
      const message =
        maybeMessage ??
        Object.entries(ErrorCodes).find(([, val]) => val === code)?.[0] ??
        "Unknown error";
      const reason = message.slice(0, 123);
      console.log(`Closed with ${code} and ${reason}`);
      // Ensures reason is within byte limit
      this.ws.close(code, reason);
    } else if (typeof codeOrMessage === "string") {
      const reason = codeOrMessage.slice(0, 123);
      this.ws.close(1000, reason); // 1000 is the normal closure code
    } else {
      this.ws.close();
    }
  }

}

export default WebSocketResponder;
