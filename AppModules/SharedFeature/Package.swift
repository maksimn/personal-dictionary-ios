// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "SharedFeature",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "SharedFeature",
            targets: ["SharedFeature"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/scalessec/Toast-Swift", from: "5.0.1"),
        .package(path: "../CoreModule")
    ],
    targets: [
        .target(
            name: "SharedFeature",
            dependencies: [
                "CoreModule",
                .product(name: "Toast", package: "Toast-Swift")
            ],
            path: "Source"
        )
    ]
)
