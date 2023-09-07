// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "SharedFeature",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "SharedFeature",
            targets: ["SharedFeature"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift", revision: "6.5.0"),
        .package(url: "https://github.com/scalessec/Toast-Swift", from: "5.0.1"),
        .package(path: "../CoreModule")
    ],
    targets: [
        .target(
            name: "SharedFeature",
            dependencies: [
                "CoreModule",
                "RxSwift",
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "Toast", package: "Toast-Swift")
            ],
            path: "Source"
        )
    ]
)
