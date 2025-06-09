const WebSocket = require('ws');

// Replace with your desired user credentials
const userCredentials = {
  type: 'Authentication',
  data: {
    email: 'testuser@example.com',
    userName: 'TestUser',
    profileImage: 'https://example.com/profile.jpg'
  }
};

// Connect to your WebSocket server
const ws = new WebSocket('ws://localhost:8055/authenticate');

ws.on('open', () => {
  console.log('[CLIENT] Connection opened to server');
});

ws.on('message', (message) => {
  try {
    const parsed = JSON.parse(message);
    console.log('[SERVER]', parsed);

    if (parsed === 2001 || parsed.code === 2001) {
      console.log('[CLIENT] Awaiting credentials...');
      ws.send(JSON.stringify(userCredentials));
    }

    if (parsed.resType === 'AUTH_TOKENS') {
      console.log('[CLIENT] Received tokens:', parsed.data);
      // TODO: Store tokens or proceed with app flow
    }
  } catch (err) {
    console.error('[CLIENT] Invalid message:', message);
  }
});

ws.on('close', (code, reason) => {
  console.log(`[CLIENT] Connection closed. Code: ${code}, Reason: ${reason}`);
});

ws.on('error', (err) => {
  console.error('[CLIENT] WebSocket error:', err.message);
});
