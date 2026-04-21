
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
3. Choose the version tag (for example, `1.0.0`) and add it to your project.
4. Import the SDK in your Swift files:
```swift
import BeaconMeshSDK
```


## Usage
**Initialize the SDK**


```swift
let client = try BeaconMeshClient(apiKey: "YOUR_API_KEY")
client.delegate = self
```

**Start the SDK**

You can optionally provide a user identity. If not provided, the SDK will generate one automatically.

```swift
let client = BeaconMeshClient()
client.delegate = self

Task {
    do {
        try await client.start()
    } catch {
        print("Failed to start BeaconMeshSDK:", error)
    }
}
```

Or with a specific user ID:
```swift
try await client.start(userId: myUUID)
```

**Stop the SDK**
```swift
client.stop()
```

**Current UUID**

Unique identifier used for mesh communication.
```swift
let uuid = client.currentUUID
```
The UUID:

* Generated automatically if no userId is provided in start()
* Can be manually controlled via start(userId:)
* persists across app launches
* changes only after calling resetSession()

**Reset Session**

Reset the current SDK identity and generate a new UUID on the next start.
```swift
client.resetSession()

try await client.start()

print(client.currentUUID) // new UUID
```

Use cases:

* user logout
* switching accounts
* resetting corrupted sessions

## Sending Messages
**Peer-to-Peer Message**

```swift
let payload = "Hello".data(using: .utf8)!
let peerUUID: UUID = ...

do {
    let messageId = try client.sendP2PMessage(payload, to: peerUUID)
    print("Message sent with id:", messageId)
} catch {
    print("Failed to send P2P message:", error)
}
```

**Broadcast Message**
```swift
let payload = "Hello everyone".data(using: .utf8)!

do {
    let messageId = try client.sendBroadcastMessage(payload)
    print("Broadcast sent with id:", messageId)
} catch {
    print("Failed to send broadcast message:", error)
}
```

## Delegate Methods

**Implement the BeaconMeshClientDelegate to receive events:**

```swift
extension MyClass: BeaconMeshClientDelegate {

    // MARK: Lifecycle Events
    func beaconMeshClientDidStart(_ client: BeaconMeshClient) {
        print("The SDK has successfully started and is ready to operate.")
    }

    func beaconMeshClientDidStop(_ client: BeaconMeshClient) {
        print("The SDK has successfully stoped.")
    }

    // MARK: Messages
    
    func beaconMeshClient(
        _ client: BeaconMeshClient,
        didReceiveP2PMessage payload: Data,
        with messageId: UUID,
        from peerID: UUID
    ) {
        print("P2P message from:", peerID)
    }

    func beaconMeshClient(
        _ client: BeaconMeshClient,
        didReceiveBroadcastMessage payload: Data,
        with messageId: UUID,
        from peerID: UUID
    ) {
        print("Broadcast message from:", peerID)
    }

    // MARK: Beacons
    
    func beaconMeshClient(
        _ client: BeaconMeshClient,
        didDetectBeacon beacon: Beacon
    ) {
        print("Beacon detected:", beacon)
    }

    func beaconMeshClient(
        _ client: BeaconMeshClient,
        didLoseBeacon beacon: Beacon
    ) {
        print("Beacon lost:", beacon)
    }

    // MARK: Peers
    
    func beaconMeshClient(
        _ client: BeaconMeshClient,
        peerDidConnect peerUUID: UUID
    ) {
        print("Peer connected:", peerUUID)
    }

    func beaconMeshClient(
        _ client: BeaconMeshClient,
        peerDidDisconnect peerUUID: UUID
    ) {
        print("Peer disconnected:", peerUUID)
    }

    // MARK: Errors
    
    func beaconMeshClient(
        _ client: BeaconMeshClient,
        didEncounterError error: BeaconMeshClientError
    ) {
        print("SDK error:", error)
    }
}
```

## Notes

Make sure Bluetooth and Location permissions are granted at runtime.

The SDK uses background Bluetooth scanning to detect nearby devices and beacons.

The start(apiKey:) method must be called before sending or receiving messages.

UUID is only available after the SDK starts

Resetting the session invalidates the current identity
