# How to build

## Build and run from command line

bazel build //:ChatGPTDemoApp
bazel run //:ChatGPTDemoApp

*Note: Currently the build fails to compile core data models* 
```
INFO: Analyzed target //:ChatGPTDemoApp (1 packages loaded, 15 targets configured).
ERROR: /Users/cs2be/programming/chatgpt_demo/ChatGPTDemoiOS/BUILD:24:14: Compiling Swift module //:lib failed: (Exit 1): worker failed: error executing SwiftCompile command (from target //:lib) bazel-out/darwin_arm64-opt-exec-ST-13d3ddad9198/bin/external/rules_swift~1.13.0/tools/worker/worker swiftc ... (remaining 1 argument skipped)
remark: Incremental compilation has been disabled: ChatThread+CoreDataClass.swift has no swiftDeps file
remark: Incremental compilation has been disabled: ChatThread+CoreDataClass.swift has no swiftDeps file
remark: Incremental compilation has been disabled: malformed dependencies file 'none?!'
remark: Incremental compilation has been disabled: ChatThread+CoreDataProperties.swift has no swiftDeps file
remark: Incremental compilation has been disabled: ChatThread+CoreDataProperties.swift has no swiftDeps file
remark: Incremental compilation has been disabled: malformed dependencies file 'none?!'
remark: Incremental compilation has been disabled: CoreDataModel+CoreDataModel.swift has no swiftDeps file
remark: Incremental compilation has been disabled: CoreDataModel+CoreDataModel.swift has no swiftDeps file
remark: Incremental compilation has been disabled: malformed dependencies file 'none?!'
swift_worker: Could not copy bazel-out/ios_sim_arm64-fastbuild-ios-sim_arm64-min15.0-applebin_ios-ST-52085178dc52/bin/_swift_incremental/lib_objs/coredatamodel.coreDataModel.coredata.sources.o to bazel-out/ios_sim_arm64-fastbuild-ios-sim_arm64-min15.0-applebin_ios-ST-52085178dc52/bin/lib_objs/coredatamodel.coreDataModel.coredata.sources.o (No such file or directory)
Target //:ChatGPTDemoApp failed to build
Use --verbose_failures to see the command lines of failed build steps.
INFO: Elapsed time: 1.061s, Critical Path: 0.94s
INFO: 2 processes: 2 internal.
ERROR: Build did NOT complete successfully
```

## Build xcode project

bazel run //:xcodeproj

## Resources

https://github.com/bazelbuild/rules_apple/blob/master/doc/tutorials/ios-app.md