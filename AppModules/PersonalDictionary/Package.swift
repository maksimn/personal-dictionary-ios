// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "PersonalDictionary",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "PersonalDictionary",
            targets: ["PersonalDictionary"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.6.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift", revision: "6.5.0"),
        .package(path: "../CoreModule"),
        .package(path: "../TodoList")
    ],
    targets: [
        .target(
            name: "PersonalDictionary",
            dependencies: [
                "CoreModule", "RxSwift", "SnapKit", "TodoList", .product(name: "RxCocoa", package: "RxSwift")
            ],
            path: "Source",
            resources: []
        ),
        .testTarget(
            name: "PersonalDictionaryTests",
            dependencies: ["PersonalDictionary", .product(name: "RxBlocking", package: "RxSwift")],
            path: "Tests"
        )
    ]
)
