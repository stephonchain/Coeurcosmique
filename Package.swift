// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CoeurCosmique",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "TarotCore",
            targets: ["TarotCore"]
        )
    ],
    targets: [
        .target(
            name: "TarotCore"
        ),
        .testTarget(
            name: "TarotCoreTests",
            dependencies: ["TarotCore"]
        )
    ]
)
