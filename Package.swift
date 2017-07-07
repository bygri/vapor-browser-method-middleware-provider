import PackageDescription

let package = Package(
    name: "BrowserMethodMiddlewareProvider",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
    ]
)
