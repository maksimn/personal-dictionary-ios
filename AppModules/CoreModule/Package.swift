// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "CoreModule",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "CoreModule",
            targets: ["CoreModule"]
        )
    ],
    targets: [
        .target(
            name: "CoreModule",
            path: "Source"
        )
    ]
)
