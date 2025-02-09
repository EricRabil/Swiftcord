// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "Swiftcord",
  platforms: [.macOS("12") ],
  products: [
    .library(name: "Swiftcord", targets: ["Swiftcord"])
  ],
  dependencies: [
    // WebSockets for Linux and macOS
    .package(url: "https://github.com/vapor/websocket-kit", from: "2.6.1"),
    // Logging for Swift
    .package(url: "https://github.com/apple/swift-log.git", from: "1.4.2"),
    // Library that contains common mimetypes
    .package(url: "https://github.com/sendyhalim/Swime", from: "3.0.7"),
    // Library for decoding from dictionaries
    .package(url: "https://github.com/almazrafi/DictionaryCoder", from: "1.1.0")
  ],
  targets: [
    .target(
      name: "Swiftcord",
      dependencies: [.product(name: "WebSocketKit", package: "websocket-kit"), .product(name: "Logging", package: "swift-log"), "Swime", "DictionaryCoder"]
    ),
    .testTarget(
        name: "SwiftcordTests",
        dependencies: [.target(name: "Swiftcord")]
    )
  ]
)
