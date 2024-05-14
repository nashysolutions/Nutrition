// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "networking",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Networking",
            targets: ["Networking"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", exact: "1.0.0")
    ],
    targets: [
        .target(
            name: "Networking",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies")
            ]
        ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: [
                "Networking",
                    .product(name: "Dependencies", package: "swift-dependencies")
            ]
        )
    ]
)
