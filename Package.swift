import PackageDescription

let package = Package(
    name: "iotapp",
    dependencies:[
      .Package(url:"https://github.com/Zewo/Epoch.git", majorVersion:0, minor:1),
      .Package(url:"https://github.com/Zewo/Middleware.git", majorVersion:0, minor:1),
      .Package(url:"https://github.com/Zewo/PostgreSQL.git", majorVersion: 0, minor:1),
//        .Package(url:"https://github.com/SwiftyBeaver/SwiftyBeaver", majorVersion:0, minor:3)
    ]
)
