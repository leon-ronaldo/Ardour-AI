import WebSocket from "ws";

interface ClientWS {
  id: string;
  ws: WebSocket;
}

const clients: ClientWS[] = [];

const addClient = (id: string, ws: WebSocket) => {
  // Avoid duplicates
  removeClient(id);
  clients.push({ id, ws });
};

const removeClient = (id: string) => {
  const index = clients.findIndex(c => c.id === id);
  if (index !== -1) {
    clients.splice(index, 1);
  }
};

const getClient = (id: string): WebSocket | undefined => {
  return clients.find(c => c.id === id)?.ws;
};

const broadcast = (message: any) => {
  clients.forEach(c => c.ws.send(JSON.stringify(message)));
};

export default {
  addClient,
  removeClient,
  getClient,
  broadcast
};
