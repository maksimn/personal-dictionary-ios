// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "TodoList",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
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
