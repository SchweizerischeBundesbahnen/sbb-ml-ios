//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import Foundation
import UIKit

class Logger {
    
    enum LogLevel: String {
        case debug
        case info
        case error
    }
    
    private static let logger = Logger()
    
    static func log(_ text: String, _ level: LogLevel) {
        logger.log(text, level)
    }
    
    private func log(_ text: String, _ level: LogLevel) {
        let logLine = "\(Date()) [\(level)] : \(text)"
        print(logLine)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
