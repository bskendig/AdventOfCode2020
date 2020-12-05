// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "AdventOfCode2020",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "AdventOfCode2020Runner",
            targets: [
                "AdventOfCode2020Runner"
            ]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/Apple/swift-argument-parser",
            from: "0.3.0"
        ),
        .package(
            url: "https://github.com/Realm/SwiftLint",
            from: "0.41.0"
        ),
        .package(
            url: "https://github.com/shibapm/Komondor.git",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "AdventOfCode2020Runner",
            dependencies: [
                "AdventOfCode2020",
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                )
            ]
        ),
        .target(
            name: "AdventOfCode2020",
            resources: [
                .copy("Resources/inputs")
            ]
        ),
        .testTarget(
            name: "AdventOfCode2020Tests",
            dependencies: [
                "AdventOfCode2020"
            ]
        )
    ]
)

#if canImport(PackageConfig)
import PackageConfig

let config = PackageConfiguration([
    "komondor": [
        "pre-commit": [
            "sh Scripts/swiftlint-hook.sh"
        ]
    ]
]).write()
#endif
