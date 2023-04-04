// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "CoreModule",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CoreModule",
            targets: ["CoreModule"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift", revision: "6.5.0")
    ],
    targets: [
        .target(
            name: "CoreModule",
            dependencies: ["RxSwift", .product(name: "RxCocoa", package: "RxSwift")],
            path: "Source"
        )
    ]
)
