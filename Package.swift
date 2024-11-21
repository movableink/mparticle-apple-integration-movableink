// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "mParticle-Integration-MovableInk",
    platforms: [ .iOS(.v13), .tvOS(.v13) ], 
    products: [
        .library(
            name: "mParticle-Integration-MovableInk",
            targets: ["mParticle-Integration-MovableInk"]
        ),
    ],
    dependencies: [
      .package(url: "https://github.com/mParticle/mparticle-apple-sdk", from: "8.0.0"),
      .package(url: "https://github.com/movableink/ios-sdk", from: "1.7.1")
    ],
    targets: [
        .target(
            name: "mParticle-Integration-MovableInk",
            dependencies: [
              .product(name: "mParticle-Apple-SDK", package: "mParticle-Apple-SDK"),
              .product(name: "MovableInk", package: "ios-sdk")
            ],
            path: "mParticle-MovableInk",
            publicHeadersPath: "."
        ),
    ]
)
