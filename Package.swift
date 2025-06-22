// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Kaveh-Common",
    platforms: [.iOS(.v17), .macOS(.v14)],
    
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Kaveh-Common",
            targets: ["Kaveh-Common"]
        ),
    ],
    dependencies: [
            .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
//            .package(url: "https://github.com/gohanlon/swift-memberwise-init-macro", from: "0.5.1")
        ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Kaveh-Common",
//            dependencies: ["MemberwiseInitMacro"]
            
        ),
        .testTarget(
            name: "Kaveh-CommonTests",
            dependencies: ["Kaveh-Common"]
        ),
    ]
)
