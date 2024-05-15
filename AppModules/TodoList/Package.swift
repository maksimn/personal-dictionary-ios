// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "TodoList",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "TodoList",
            targets: ["TodoList"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.2.0"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.6.0"),
        .package(path: "../CoreModule"),
        .package(path: "../SharedFeature")
    ],
    targets: [
        .target(
            name: "TodoList",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "CoreModule",
                "SharedFeature",
                "SnapKit"
            ],
            path: "Source",
            resources: []
        ),
        .testTarget(
            name: "TodoListTests",
            dependencies: ["TodoList"],
            path: "Tests"
        )
    ]
)
