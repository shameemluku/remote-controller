# Mobile App Development Guide

## Android App Implementation

### 1. Prerequisites

- Android Studio
- Android device with IR blaster (e.g., Xiaomi, Samsung Galaxy S series, Huawei)
- Minimum SDK: 19 (KitKat 4.4)

### 2. Project Setup

#### build.gradle (app level)
```gradle
dependencies {
    implementation 'com.squareup.okhttp3:okhttp:4.11.0'
    implementation 'org.java-websocket:Java-WebSocket:1.5.4'
    implementation 'com.google.code.gson:gson:2.10.1'
}
```

#### AndroidManifest.xml
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.TRANSMIT_IR" android:required="false" />
<uses-feature android:name="android.hardware.consumerir" android:required="true" />
```

### 3. Main Components

#### WebSocketClient.java
```java
import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;
import java.net.URI;

public class IRWebSocketClient extends WebSocketClient {
    private IRController irController;

    public IRWebSocketClient(URI serverUri, IRController controller) {
        super(serverUri);
        this.irController = controller;
    }

    @Override
    public void onOpen(ServerHandshake handshakedata) {
        Log.d("WebSocket", "Connected to server");
    }

    @Override
    public void onMessage(String message) {
        // Parse command and execute IR
        irController.handleCommand(message);
    }

    @Override
    public void onClose(int code, String reason, boolean remote) {
        Log.d("WebSocket", "Disconnected");
    }

    @Override
    public void onError(Exception ex) {
        Log.e("WebSocket", "Error: " + ex.getMessage());
    }
}
```

#### IRController.java
```java
import android.content.Context;
import android.hardware.ConsumerIrManager;
import org.json.JSONObject;

public class IRController {
    private ConsumerIrManager irManager;
    private Context context;
    
    // IR carrier frequency (usually 38kHz for AC)
    private static final int CARRIER_FREQUENCY = 38000;

    public IRController(Context context) {
        this.context = context;
        irManager = (ConsumerIrManager) context.getSystemService(Context.CONSUMER_IR_SERVICE);
    }

    public boolean hasIrEmitter() {
        return irManager != null && irManager.hasIrEmitter();
    }

    public void handleCommand(String jsonCommand) {
        try {
            JSONObject command = new JSONObject(jsonCommand);
            String type = command.getString("type");

            switch (type) {
                case "SET_TEMPERATURE":
                    int temp = command.getInt("temperature");
                    setTemperature(temp);
                    break;
                case "SET_POWER":
                    boolean power = command.getBoolean("power");
                    setPower(power);
                    break;
                case "SET_MODE":
                    String mode = command.getString("mode");
                    setMode(mode);
                    break;
            }
        } catch (Exception e) {
            Log.e("IRController", "Error handling command: " + e.getMessage());
        }
    }

    private void setTemperature(int temperature) {
        int[] pattern = getTemperaturePattern(temperature);
        transmitIR(pattern);
    }

    private void setPower(boolean on) {
        int[] pattern = on ? ACPatterns.POWER_ON : ACPatterns.POWER_OFF;
        transmitIR(pattern);
    }

    private void setMode(String mode) {
        int[] pattern = ACPatterns.getModePattern(mode);
        transmitIR(pattern);
    }

    private void transmitIR(int[] pattern) {
        if (hasIrEmitter()) {
            irManager.transmit(CARRIER_FREQUENCY, pattern);
            Log.d("IRController", "IR signal transmitted");
        } else {
            Log.e("IRController", "No IR emitter available");
        }
    }

    private int[] getTemperaturePattern(int temp) {
        // Return pattern for specific temperature
        // This needs to be customized for your AC model
        return ACPatterns.getTemperaturePattern(temp);
    }
}
```

#### ACPatterns.java
```java
public class ACPatterns {
    // These are example patterns - you need to capture actual IR codes
    // for your specific AC model using IR learning tools
    
    public static final int[] POWER_ON = {
        9000, 4500, 560, 560, 560, 560, 560, 1690, 560, 560,
        // ... rest of the pattern
    };

    public static final int[] POWER_OFF = {
        9000, 4500, 560, 560, 560, 1690, 560, 560, 560, 560,
        // ... rest of the pattern
    };

    public static int[] getTemperaturePattern(int temperature) {
        // Map temperature to IR pattern
        // This is AC model specific
        switch (temperature) {
            case 16: return TEMP_16;
            case 17: return TEMP_17;
            // ... etc
            case 30: return TEMP_30;
            default: return TEMP_24;
        }
    }

    public static int[] getModePattern(String mode) {
        switch (mode.toLowerCase()) {
            case "cool": return MODE_COOL;
            case "heat": return MODE_HEAT;
            case "fan": return MODE_FAN;
            case "dry": return MODE_DRY;
            case "auto": return MODE_AUTO;
            default: return MODE_COOL;
        }
    }

    // Define patterns for each temperature
    private static final int[] TEMP_16 = { /* IR pattern */ };
    private static final int[] TEMP_24 = { /* IR pattern */ };
    private static final int[] TEMP_30 = { /* IR pattern */ };
    
    // Define patterns for each mode
    private static final int[] MODE_COOL = { /* IR pattern */ };
    private static final int[] MODE_HEAT = { /* IR pattern */ };
    // ... etc
}
```

#### MainActivity.java
```java
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import java.net.URI;

public class MainActivity extends AppCompatActivity {
    private IRWebSocketClient webSocketClient;
    private IRController irController;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Initialize IR controller
        irController = new IRController(this);
        
        if (!irController.hasIrEmitter()) {
            // Show error: device doesn't have IR blaster
            return;
        }

        // Connect to WebSocket server
        connectToServer("ws://YOUR_SERVER_IP:8080");
    }

    private void connectToServer(String serverUrl) {
        try {
            URI uri = new URI(serverUrl);
            webSocketClient = new IRWebSocketClient(uri, irController);
            webSocketClient.connect();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (webSocketClient != null) {
            webSocketClient.close();
        }
    }
}
```

### 4. Capturing IR Codes

#### Method 1: Use Existing Apps
- **IR Remote Control** (Play Store)
- **AnyMote** - Has learning mode
- **Mi Remote** - For Xiaomi devices

#### Method 2: Arduino + IR Receiver
```arduino
#include <IRremote.h>

int RECV_PIN = 11;
IRrecv irrecv(RECV_PIN);
decode_results results;

void setup() {
  Serial.begin(9600);
  irrecv.enableIRIn();
}

void loop() {
  if (irrecv.decode(&results)) {
    Serial.println(results.value, HEX);
    irrecv.resume();
  }
}
```

#### Method 3: Android IR Learning Code
```java
// Use apps like "IR Remote Control" which have built-in learning
// Or implement your own IR receiver if device supports it
```

### 5. Testing

1. Build and install the Android app
2. Start the Node.js server
3. Launch the app (it will connect via WebSocket)
4. Send API request from Postman
5. App receives command and transmits IR
6. AC responds to the signal

### 6. Alternative: React Native App

If you prefer React Native:

```bash
npm install react-native-consumer-ir-manager
npm install react-native-websocket
```

## Quick Start Checklist

- [ ] Check if your phone has IR blaster
- [ ] Install Node.js server
- [ ] Create Android project
- [ ] Add WebSocket client
- [ ] Implement IR transmission
- [ ] Capture your AC's IR codes
- [ ] Map commands to IR patterns
- [ ] Test with Postman

## Recommended Devices with IR Blasters

- Xiaomi Mi series (Mi 9, Mi 10, etc.)
- Samsung Galaxy S series (S6, S7, etc.)
- Huawei P series
- LG G series
- HTC One series

**Note:** Most modern phones have removed IR blasters. Check your device specs first!
