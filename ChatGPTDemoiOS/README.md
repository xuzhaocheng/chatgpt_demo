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

## Update Info.plist

Open up Info.plist and replace the values for "OpenAIAPIKey" and "OpenAIAssistantId" before you build and run the app.  You can create these from OpenAI platform page:  https://platform.openai.com/

## Setting up LM Studio to test out local LLVM models with AirGPT demo

- Download LM Studios:  https://lmstudio.ai/
- Download LLVM model of your choice.  I recommend using Llama 2 7B
- Start up LM Studio local inference server.  Make sure it points to http://localhost:1234.

## Build xcode project

bazel run //:xcodeproj

## Resources

https://github.com/bazelbuild/rules_apple/blob/master/doc/tutorials/ios-app.md