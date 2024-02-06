//
//  LoggerExtension.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 2/3/24.
//

import Foundation
import OSLog

struct DisplayLog: Identifiable, Hashable {
    let id: String
    let logLevel: OSLogType
    let log: String
    let date: Date
    
    init(id: String = UUID().uuidString, _ logLevel: OSLogType, log: String) {
        self.id = id
        self.logLevel = logLevel
        self.log = log
        self.date = Date.now
    }
    
    func formattedLogString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd kk:mm:ss"
        
        let dateString = dateFormatter.string(from: self.date)
        
        switch logLevel {
        case .info:
            return "[INFO][\(dateString)]\n\(log)"
        case .error:
            return "[ERROR][\(dateString)]\n\(log)"
        default:
            return log
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Default system logs
    static let system = Logger(subsystem: subsystem, category: "data")
    
    static var logsToDisplay: [DisplayLog] = []
    
    public func infoAndCache(_ message: String) {
        self.info("\(message)")
        
        Logger.logsToDisplay = _insertIntoArray(
            DisplayLog(.info, log: message),
            array: Logger.logsToDisplay)
    }
    
    public func errorAndCache(_ message: String) {
        self.error("\(message)")

        Logger.logsToDisplay = _insertIntoArray(
            DisplayLog(.error, log: message),
            array: Logger.logsToDisplay)
    }
    
    private func _insertIntoArray(_ value: DisplayLog, array: [DisplayLog]) -> [DisplayLog] {
        var arr = array
        if arr.count == 200 { // limit logs to last 200 lines
            arr.removeLast()
        }
        arr.append(value)
        return arr
    }
}
