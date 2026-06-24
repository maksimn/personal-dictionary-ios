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
        .package(url: "https://github.com/inDriver/UDF", exact: "2.5.3"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.6.0"),
        .package(url: "https://github.com/realm/realm-swift", from: "10.39.1"),
        .package(path: "../CoreModule"),
        .package(path: "../SharedFeature"),
        .package(path: "../TodoList")
    ],
    targets: [
        .target(
            name: "PersonalDictionary",
            dependencies: [
                "CoreModule",
                "SharedFeature",
                "SnapKit",
                "TodoList",
                "UDF",
                .product(name: "RealmSwift", package: "realm-swift")
            ],
            path: "Source",
            resources: []
        ),
        .testTarget(
            name: "PersonalDictionaryTests",
            dependencies: ["PersonalDictionary"],
            path: "Tests"
        )
    ]
)
