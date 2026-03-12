
# BeaconMeshSDK

iOS SDK for discovering beacons and enabling peer-to-peer mesh communication between nearby devices.

---

## Requirements

Before using the SDK, make sure your app is configured correctly:

1. **Enable Background Mode**:
   - Go to **Capabilities → Background Modes → Use Bluetooth LE Accessories**.
2. **Add permissions to Info.plist**:
   - **Bluetooth**:
     ```xml
     <key>NSBluetoothAlwaysUsageDescription</key>
     <string>This app requires Bluetooth access to detect nearby devices.</string>
     ```
   - **Location (When in Use)**:
     ```xml
     <key>NSLocationWhenInUseUsageDescription</key>
     <string>This app requires location access to detect nearby beacons.</string>
     ```

---

## Installation

Add the SDK to your project using **Swift Package Manager**:

1. In Xcode, go to **File → Add Packages → Add Package Dependency**.
2. Enter your repository URL: https://github.com/bridgefy/BeaconMeshSDK-iOS
3. Choose the version tag (for example, `0.1.0`) and add it to your project.
4. Import the SDK in your Swift files:
```swift
import BeaconMeshSDK
```


## Usage
**Initialize and Start the SDK**

```swift
let client = BeaconMeshClient()
client.delegate = self

Task {
    do {
        try await client.start(apiKey: "YOUR_API_KEY")
    } catch {
        print("Failed to start BeaconMeshSDK:", error)
    }
}
```

**Stop the SDK**
```swift
client.stop()
```

## Sending Messages
**Peer-to-Peer Message**

```swift
let payload = "Hello!".data(using: .utf8)!
let targetUUID: UUID = // the peer UUID

client.sendP2PMessage(payload, to: targetUUID)
```

**Broadcast Message**
```swift
let payload = "Hello everyone!".data(using: .utf8)!
client.sendBroadcastMessage(payload)
```

## Delegate Methods

**Implement the BeaconMeshClientDelegate to receive events:**

```swift
extension YourClass: BeaconMeshClientDelegate {
    
    func beaconMeshClient(_ client: BeaconMeshClient, didReceiveP2PMessage payload: Data) {
        print("Received P2P message:", payload)
    }

    func beaconMeshClient(_ client: BeaconMeshClient, didReceiveBroadcastMessage payload: Data) {
        print("Received broadcast message:", payload)
    }

    func beaconMeshClient(_ client: BeaconMeshClient, didDetectBeacon beacon: Beacon) {
        print("Detected beacon:", beacon)
    }

    func beaconMeshClient(_ client: BeaconMeshClient, didLoseBeacon beacon: Beacon) {
        print("Lost beacon:", beacon)
    }

    func beaconMeshClient(_ client: BeaconMeshClient, peerDidConnect peerUUID: UUID) {
        print("Peer connected:", peerUUID)
    }

    func beaconMeshClient(_ client: BeaconMeshClient, peerDidDisconnect peerUUID: UUID) {
        print("Peer disconnected:", peerUUID)
    }

    func beaconMeshClient(_ client: BeaconMeshClient, didEncounterError error: BeaconMeshClientError) {
        print("SDK Error:", error)
    }
}
```

## Notes

Make sure Bluetooth and Location permissions are granted at runtime.

The SDK uses background Bluetooth scanning to detect nearby devices and beacons.

The start(apiKey:) method must be called before sending or receiving messages.
