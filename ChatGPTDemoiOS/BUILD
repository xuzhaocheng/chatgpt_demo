load("@rules_apple//apple:ios.bzl", "ios_application")
load("@rules_swift//swift:swift.bzl", "swift_library")
load(
    "@rules_swift//swift/internal:swift_common.bzl",
    "swift_common",
)
load(
    "@rules_xcodeproj//xcodeproj:defs.bzl",
    "top_level_target",
    "xcodeproj",
)
load(
    "@rules_apple//apple/internal:swift_info_support.bzl",
    "swift_info_support",
)
load("@gazelle//:def.bzl", "gazelle", "gazelle_binary")
load("@rules_swift_package_manager//swiftpkg:defs.bzl", "swift_update_packages")

# Ignore the `.build` folder that is created by running Swift package manager
# commands. The Swift Gazelle plugin executes some Swift package manager
# commands to resolve external dependencies. This results in a `.build` file
# being created.
# NOTE: Swift package manager is not used to build any of the external packages.
# The `.build` directory should be ignored. Be sure to configure your source
# control to ignore it (i.e., add it to your `.gitignore`).
# gazelle:exclude .build

# This declaration builds a Gazelle binary that incorporates all of the Gazelle
# plugins for the languages that you use in your workspace. In this example, we
# are only listing the Gazelle plugin for Swift from rules_swift_package_manager.
gazelle_binary(
    name = "gazelle_bin",
    languages = [
        "@rules_swift_package_manager//gazelle",
    ],
)

# This macro defines two targets: `swift_update_pkgs` and
# `swift_update_pkgs_to_latest`.
#
# The `swift_update_pkgs` target should be run whenever the list of external
# dependencies is updated in the `Package.swift`. Running this target will
# populate the `swift_deps.bzl` with `swift_package` declarations for all of
# the direct and transitive Swift packages that your project uses.
#
# The `swift_update_pkgs_to_latest` target should be run when you want to
# update your Swift dependencies to their latest eligible version.
swift_update_packages(
    name = "swift_update_pkgs",
    gazelle = ":gazelle_bin",
    generate_swift_deps_for_workspace = False,
    update_bzlmod_stanzas = True,
)

# This target updates the Bazel build files for your project. Run this target
# whenever you add or remove source files from your project.
gazelle(
    name = "update_build_files",
    gazelle = ":gazelle_bin",
)

swift_library(
    name = "lib",
    srcs = glob(["Sources/**/*.swift"]),
    deps = [
        "@swiftpkg_alamofire//:Source_Alamofire",
    ],
    data = [
        "//Resources:Images",
        "//Resources:listings.plist",
    ],
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
    minimum_os_version = "16.0",
    visibility = ["//visibility:public"],
    provisioning_profile = "ChatGPT_Dev_Certificate.mobileprovision",
    deps = [
        ":lib",
    ],
)

xcodeproj(
    name = "xcodeproj",
    build_mode = "bazel",
    project_name = "ChatGPTDemoApp",
    tags = ["manual"],
    top_level_targets = [
        ":ChatGPTDemoApp",
    ],
)
