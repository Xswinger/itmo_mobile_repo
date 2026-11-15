// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ZooLab",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "ZooKit", targets: ["ZooKit"]),
        .executable(name: "ZooLab", targets: ["ZooLab"])
    ],
    targets: [
        .target(name: "ZooKit"),
        .executableTarget(name: "ZooLab", dependencies: ["ZooKit"])
    ]
)
