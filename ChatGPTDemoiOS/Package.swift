// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "my-project",
    dependencies: [
        // Replace these entries with your dependencies.
        // .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        // .package(url: "https://github.com/apple/swift-log", from: "1.4.4"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.8.1"))
    ]
)