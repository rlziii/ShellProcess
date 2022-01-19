// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "ShellProcess",
    platforms: [
        .macOS(.v11),
    ],
    products: [
        .library(name: "ShellProcess", targets: ["ShellProcess"]),
    ],
    targets: [
        .target(name: "ShellProcess"),
        .testTarget(name: "ShellProcessTests", dependencies: ["ShellProcess"]),
    ]
)
