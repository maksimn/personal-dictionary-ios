// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "PersonalDictionary",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14)
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
        .package(url: "https://github.com/realm/realm-swift", from: "10.39.1"),
        .package(url: "https://github.com/scalessec/Toast-Swift", from: "5.0.1"),
        .package(path: "../CoreModule"),
        .package(path: "../TodoList")
    ],
    targets: [
        .target(
            name: "PersonalDictionary",
            dependencies: [
                "CoreModule",
                "RxSwift",
                "SnapKit",
                "TodoList",
                .product(name: "RealmSwift", package: "realm-swift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "Toast", package: "Toast-Swift")
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
