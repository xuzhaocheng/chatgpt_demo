import UIKit
import XCPlayground
import PlaygroundSupport

let fileManager = FileManager.default

let fileURL = playgroundSharedDataDirectory.appendingPathComponent("test.html")

do {
    let text = try String(contentsOf: fileURL, encoding: .utf8)
    print(text)
} catch let error as NSError {
    print("Error loading file \(error.userInfo)")
}
