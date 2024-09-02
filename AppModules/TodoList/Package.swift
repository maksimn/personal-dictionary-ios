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
        .package(path: "../CoreModule")
    ],
    targets: [
        .target(
            name: "TodoList",
            dependencies: [
                "CoreModule"
            ],
            path: "Source",
            resources: []
        )
    ]
)
