# How to build

## Update swift packages

```
bazel run //:swift_update_pkgs
```
## Build and run from command line

Simulator:

```
bazel build //:ChatGPTDemoApp
bazel run //:ChatGPTDemoApp
```

Device:

```
bazel build //:ChatGPTDemoApp --apple_platform_type=ios --ios_multi_cpus=arm64
```

## Build xcode project

bazel run //:xcodeproj

## Update Info.plist

Open up Info.plist and replace the values for "OpenAIAPIKey" and "OpenAIAssistantId" before you build and run the app

## Resources

https://github.com/bazelbuild/rules_apple/blob/master/doc/tutorials/ios-app.md