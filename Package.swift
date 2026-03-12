// swift-tools-version: 6.2
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
        .package(url: "https://github.com/bridgefy/sdk-ios.git", from: "1.3.3"),
        .package(url: "https://github.com/aws-amplify/aws-sdk-ios-spm", from: "2.0.0")
    ],
    
    targets: [
        
        // Binary SDK
        .binaryTarget(
            name: "BeaconMeshBinary",
            path: "Frameworks/BeaconMesh.xcframework"
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
