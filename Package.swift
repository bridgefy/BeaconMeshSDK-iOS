// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BeaconMesh",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "BeaconMesh",
            targets: ["BeaconMeshWrapper"]
        )
    ],
    
    dependencies: [
        .package(url: "https://github.com/bridgefy/sdk-ios.git", from: "1.3.7"),
        .package(url: "https://github.com/aws-amplify/aws-sdk-ios-spm", from: "2.0.0")
    ],
    
    targets: [
        
        // Binary SDK
        .binaryTarget(
            name: "BeaconMeshBinary",
            url: "https://github.com/FranciscoMkdir/BeaconMeshSDK-iOS-binary/releases/download/1.0.11/BeaconMesh.xcframework.zip",
            checksum: "d39e57c812f48fb23fad35b88696ada2eea362ff4ded326b9230098f7e9a6bdb"
        ),
        
        .target(
            name: "BeaconMeshWrapper",
            dependencies: [
                "BeaconMeshBinary",
                .product(name: "BridgefySDK", package: "sdk-ios"),
                .product(name: "AWSLogs", package: "aws-sdk-ios-spm")
            ],
            path: "Sources/BeaconMeshWrapper"
        )
    ]
)
