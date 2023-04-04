// swift-tools-version:5.6

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
        .package(url: "https://github.com/SnapKit/SnapKit", from: "4.0.0"),
        .package(path: "../CoreModule")
    ],
    targets: [
        .target(
            name: "TodoList",
            dependencies: ["SnapKit", "CoreModule"],
            path: "Source",
            resources: [
                // .copy("Resources/Assets.xcassets"),
                // .copy("Resources/TodoList.xcdatamodeld")
            ]
        )
    ]
)
