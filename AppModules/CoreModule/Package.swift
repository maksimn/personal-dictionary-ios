// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "CoreModule",
    platforms: [
        .iOS(.v17)
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
