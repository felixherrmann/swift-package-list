// swift-tools-version:6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-package-list",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v11),
        .macCatalyst(.v15),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8),
        .visionOS(.v1),
    ],
    products: [
        .executable(name: "swift-package-list", targets: ["swift-package-list"]),
        .plugin(name: "SwiftPackageListPlugin", targets: ["SwiftPackageListPlugin"]),
        .library(name: "SwiftPackageList", targets: ["SwiftPackageList"]),
        .library(name: "SwiftPackageListUI", targets: ["SwiftPackageListUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.1"),
    ],
    targets: [
        .executableTarget(
            name: "swift-package-list",
            dependencies: [
                .target(name: "SwiftPackageListCore"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .plugin(
            name: "SwiftPackageListPlugin",
            capability: .buildTool(),
            dependencies: [.target(name: "swift-package-list")]
        ),
        .target(
            name: "SwiftPackageListCore",
            dependencies: [.target(name: "SwiftPackageList")]
        ),
        .target(
            name: "SwiftPackageList",
            resources: [.process("Resources")]
        ),
        .target(
            name: "SwiftPackageListUI",
            dependencies: [.target(name: "SwiftPackageList")],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "swift-package-list-tests",
            dependencies: [.target(name: "swift-package-list")],
            resources: [.copy("Resources")]
        ),
        .testTarget(
            name: "SwiftPackageListCoreTests",
            dependencies: [.target(name: "SwiftPackageListCore")],
            resources: [.copy("Resources")]
        ),
        .testTarget(
            name: "SwiftPackageListTests",
            dependencies: [.target(name: "SwiftPackageList")],
            resources: [.process("Resources")]
        ),
    ]
)
