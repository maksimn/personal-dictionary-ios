// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "PersonalDictionary",
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
        .package(url: "https://github.com/ReactiveX/RxSwift", revision: "6.5.0"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "4.0"),
        .package(path: "../CoreModule", from: "0.0.0"),
        .package(path: "../TodoList", from: "0.0.0")
    ],
    targets: [
        .target(
            name: "PersonalDictionary",
            path: "Source",
            resources: [
                .copy("Resources/Assets.xcassets"),
                .copy("Resources/StorageModel.xcdatamodeld"),
                .copy("Resources/Localizable")
            ]
        )
    ]
)
