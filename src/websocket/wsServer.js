const WebSocket = require('ws');
const { v4: uuidv4 } = require('uuid');

let wss = null;
const connectedClients = new Map();

/**
 * Initialize WebSocket Server
 * @param {http.Server} server - The HTTP server instance to attach WebSocket to
 */
function initWebSocketServer(server) {
  wss = new WebSocket.Server({ server });

  wss.on('connection', (ws, req) => {
    const deviceId = uuidv4();
    const clientIp = req.socket.remoteAddress;

    console.log(`📱 New device connected: ${deviceId} from ${clientIp}`);

    // Store client connection
    connectedClients.set(deviceId, {
      ws: ws,
      deviceId: deviceId,
      ip: clientIp,
      connectedAt: new Date().toISOString()
    });

    // Send device ID to client
    ws.send(JSON.stringify({
      type: 'CONNECTION_SUCCESS',
      deviceId: deviceId,
      message: 'Connected to IR Blast API Server'
    }));

    // Handle messages from mobile device
    ws.on('message', (message) => {
      try {
        const data = JSON.parse(message);
        console.log(`📩 Received from ${deviceId}:`, data);

        // Handle device responses
        if (data.type === 'COMMAND_EXECUTED') {
          console.log(`✅ Command executed successfully on device ${deviceId}`);
        } else if (data.type === 'COMMAND_FAILED') {
          console.error(`❌ Command failed on device ${deviceId}:`, data.error);
        }
      } catch (error) {
        console.error('Error parsing message:', error);
      }
    });

    // Handle disconnection
    ws.on('close', () => {
      console.log(`📴 Device disconnected: ${deviceId}`);
      connectedClients.delete(deviceId);
    });

    // Handle errors
    ws.on('error', (error) => {
      console.error(`Error with device ${deviceId}:`, error);
    });
  });

  console.log(`🔌 WebSocket Server initialized and running on same port as HTTP server`);
}

/**
 * Send command to a specific device
 */
async function sendCommandToDevice(deviceId, command) {
  return new Promise((resolve) => {
    // If no deviceId provided, send to most recently connected device
    if (!deviceId && connectedClients.size > 0) {
      // Get all connected clients and find the most recent one
      let latestClient = null;
      let latestTime = null;
      
      for (const [id, client] of connectedClients.entries()) {
        if (client.ws.readyState === WebSocket.OPEN) {
          const connectedTime = new Date(client.connectedAt);
          if (!latestTime || connectedTime > latestTime) {
            latestTime = connectedTime;
            latestClient = id;
          }
        }
      }
      
      deviceId = latestClient;
    }

    const client = connectedClients.get(deviceId);

    if (!client) {
      resolve({
        success: false,
        error: 'Device not found or not connected'
      });
      return;
    }

    if (client.ws.readyState !== WebSocket.OPEN) {
      resolve({
        success: false,
        error: 'Device connection is not open'
      });
      return;
    }

    try {
      client.ws.send(JSON.stringify(command));
      console.log(`📤 Command sent to device ${deviceId}:`, command);
      resolve({
        success: true,
        deviceId: deviceId
      });
    } catch (error) {
      resolve({
        success: false,
        error: error.message
      });
    }
  });
}

/**
 * Get list of connected devices
 */
function getConnectedDevices() {
  return Array.from(connectedClients.values()).map(client => ({
    deviceId: client.deviceId,
    ip: client.ip,
    connectedAt: client.connectedAt
  }));
}

module.exports = {
  initWebSocketServer,
  sendCommandToDevice,
  getConnectedDevices
};
