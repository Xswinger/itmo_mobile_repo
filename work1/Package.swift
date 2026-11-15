// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DecimalLab",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "DecimalKit", targets: ["DecimalKit"]),
        .executable(name: "DecimalLab", targets: ["DecimalLab"])
    ],
    targets: [
        .target(name: "DecimalKit"),
        .executableTarget(
            name: "DecimalLab",
            dependencies: ["DecimalKit"]
        )
    ]
)
