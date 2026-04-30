// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DigiBudda",
    platforms: [.macOS(.v14)],
    targets: [
        .target(
            name: "DigiBuddaCore",
            path: "DigiBudda",
            exclude: ["App", "Views", "Resources", "Assets.xcassets", "Info.plist", "DigiBudda.entitlements"],
            sources: ["Models", "Services", "Localization"]
        ),
        .testTarget(
            name: "DigiBuddaTests",
            dependencies: ["DigiBuddaCore"],
            path: "Tests/DigiBuddaTests"
        ),
    ]
)
