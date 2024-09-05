load("@rules_apple//apple:ios.bzl", "ios_application")
load("@rules_apple//apple:resources.bzl", "apple_core_data_model")
load("@rules_swift//swift:swift.bzl", "swift_library")

load(
    "@rules_apple//apple/internal:swift_info_support.bzl",
    "swift_info_support",
)

apple_core_data_model(
   name = "coreDataModel",
   srcs = ["//Resources:CoreDataModel.xcdatamodeld"]
)

swift_library(
    name = "lib",
    srcs = glob(["Sources/**/*.swift"]) + [":coreDataModel"],
    data = ["//Resources:CoreDataModel.xcdatamodeld"]
)

ios_application(
    name = "ChatGPTDemoApp",
    bundle_id = "com.midoriapple.ChatGPTDemoApp",
    families = [
        "iphone",
        "ipad",
    ],
    infoplists = ["Info.plist"],
    launch_storyboard = "//Resources:Launch.storyboard",
    minimum_os_version = "15.0",
    visibility = ["//visibility:public"],
    deps = [":lib"],
)
