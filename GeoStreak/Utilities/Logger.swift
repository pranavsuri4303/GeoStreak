//
//  Logger.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//


import Foundation
import os.log

/// Application logger for consistent logging throughout the app
enum Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.geostreak"
    
    static let app = os.Logger(subsystem: subsystem, category: "app")
    static let data = os.Logger(subsystem: subsystem, category: "data")
    static let ui = os.Logger(subsystem: subsystem, category: "ui")
    static let network = os.Logger(subsystem: subsystem, category: "network")
    
    // Log levels
    enum Level: String {
        case debug = "DEBUG"
        case info = "INFO"
        case warning = "WARNING"
        case error = "ERROR"
    }
    
    // Log a message with the specified category and level
    static func log(_ message: String, category: os.Logger = app, level: Level = .info, file: String = #file, function: String = #function, line: Int = #line) {
        let fileURL = URL(fileURLWithPath: file)
        let fileName = fileURL.lastPathComponent
        let logMessage = "[\(fileName):\(line)] \(function) - \(message)"
        
        switch level {
        case .debug:
            category.debug("\(logMessage, privacy: .public)")
        case .info:
            category.info("\(logMessage, privacy: .public)")
        case .warning:
            category.warning("\(logMessage, privacy: .public)")
        case .error:
            category.error("\(logMessage, privacy: .public)")
        }
    }
}

// Convenience functions
func logDebug(_ message: String, category: os.Logger = Logger.app, file: String = #file, function: String = #function, line: Int = #line) {
    Logger.log(message, category: category, level: .debug, file: file, function: function, line: line)
}

func logInfo(_ message: String, category: os.Logger = Logger.app, file: String = #file, function: String = #function, line: Int = #line) {
    Logger.log(message, category: category, level: .info, file: file, function: function, line: line)
}

func logWarning(_ message: String, category: os.Logger = Logger.app, file: String = #file, function: String = #function, line: Int = #line) {
    Logger.log(message, category: category, level: .warning, file: file, function: function, line: line)
}

func logError(_ message: String, category: os.Logger = Logger.app, file: String = #file, function: String = #function, line: Int = #line) {
    Logger.log(message, category: category, level: .error, file: file, function: function, line: line)
}
