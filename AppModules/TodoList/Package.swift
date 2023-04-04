// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "TodoList",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "TodoList",
            targets: ["TodoList"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.6.0"),
        .package(path: "../CoreModule")
    ],
    targets: [
        .target(
            name: "TodoList",
            dependencies: ["SnapKit", "CoreModule"],
            path: "Source",
            resources: []
        )
    ]
)
