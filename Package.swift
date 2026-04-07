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
            targets: ["WakeApp"]
        ),
        .library(
            name: "WakeCore",
            targets: ["WakeCore"]
        ),
    ],
    targets: [
        .target(
            name: "WakeCore",
            linkerSettings: [
                .linkedFramework("IOKit"),
                .linkedFramework("ServiceManagement"),
            ]
        ),
        .executableTarget(
            name: "WakeApp",
            dependencies: ["WakeCore"]
        ),
    ]
)
