// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RollswhereEngine",
    platforms: [
        .macOS(.v10_12)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "RollswhereEngine",
            targets: ["RollswhereEngine"]),
    ],
    dependencies: [
        .package(path: "https://github.com/markorankovic/Smorgasbord")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "RollswhereEngine",
            dependencies: ["Smorgasbord"]),
        .testTarget(
            name: "RollswhereEngineTests",
            dependencies: ["RollswhereEngine"]),
    ]
)
