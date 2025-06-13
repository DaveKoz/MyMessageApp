// swift-tools-version: 6.0
// This is a Skip (https://skip.tools) package.
import PackageDescription

let package = Package(
    name: "mymessage-app",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14), .tvOS(.v17), .watchOS(.v10), .macCatalyst(.v17)],
    products: [
        .library(name: "MyMessageApp", type: .dynamic, targets: ["MyMessageApp"]),
        .library(name: "FireplaceModel", type: .dynamic, targets: ["FireplaceModel"]),
        .library(name: "LocalModel", type: .dynamic, targets: ["LocalModel"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.6.0"),
        .package(url: "https://source.skip.tools/skip-fuse-ui.git", from: "1.0.0"),
        .package(url: "https://source.skip.tools/skip-fuse.git", from: "1.0.2"),
        .package(url: "https://source.skip.tools/skip-model.git", from: "1.5.0"),
        .package(url: "https://source.skip.tools/skip-firebase.git", "0.9.0"..<"2.0.0")
    ],
    targets: [
        .target(name: "MyMessageApp", dependencies: [
            "FireplaceModel",
            .product(name: "SkipFuseUI", package: "skip-fuse-ui"),
            .product(name: "SkipFirebaseMessaging", package: "skip-firebase")
        ], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .target(name: "FireplaceModel", dependencies: [
            "LocalModel",
            .product(name: "SkipFuse", package: "skip-fuse"),
            .product(name: "SkipModel", package: "skip-model"),
            .product(name: "SkipFirebaseFirestore", package: "skip-firebase"),
            .product(name: "SkipFirebaseAuth", package: "skip-firebase")
        ], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .target(name: "LocalModel", dependencies: []),
    ]
)
