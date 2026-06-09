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
        .package(url: "https://github.com/bridgefy/sdk-ios.git", from: "1.3.5"),
        .package(url: "https://github.com/aws-amplify/aws-sdk-ios-spm", from: "2.0.0")
    ],
    
    targets: [
        
        // Binary SDK
        .binaryTarget(
            name: "BeaconMeshBinary",
            url: "https://github.com/FranciscoMkdir/BeaconMeshSDK-iOS-binary/releases/download/1.0.5/BeaconMesh.xcframework.zip",
            checksum: "d57d63226dac191ec33121ce85ba41bb5b5723de9f5dba3761f3c60746ad3645"
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
