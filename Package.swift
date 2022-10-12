// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XJCollectionViewManager",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "XJCollectionViewManager",
            targets: ["XJCollectionViewManager"]),
    ],
    targets: [
        .target(
            name: "XJCollectionViewManager",
            path: "Sources",
            publicHeadersPath: "."),
    ]
)
