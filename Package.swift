// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Wake",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(
            name: "Wake",
            targets: ["Wake"]
        ),
    ],
    targets: [
        .executableTarget(
            name: "Wake",
            linkerSettings: [
                .linkedFramework("IOKit"),
            ]
        ),
    ]
)
