//
//  Logger.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 1/9/24.
//

import Foundation
import SwiftyBeaver

private let loggingFormat = "$Dyyyy-MM-dd hh:mm:ss$d $L $M Location: $N.$F line: $l"

enum Logger {

    private static let log = SwiftyBeaver.self

    static func configure() {
        #if DEBUG
        let console = CustomConsoleDestination()
        console.levelString.info = "ℹ️"
        console.levelString.error = "‼️"
        console.levelString.warning = "⚠️"
        console.levelString.debug = "🛠"
        log.addDestination(console)
        #endif
        // Configure log file destination
        let file = FileDestination()
        file.levelString.info = "INFO"
        file.levelString.error = "ERROR"
        file.levelString.warning = "WARNING"
        file.levelString.debug = "DEBUG"

        file.levelColor.debug = ""
        file.levelColor.info = ""
        file.levelColor.warning = ""
        file.levelColor.error = ""

        file.format = loggingFormat
        
        file.logFileAmount = 2
        log.addDestination(file)
    }

    static func logPath() -> URL? {
        guard let destination = log.destinations.first(where: { $0 is FileDestination }) as? FileDestination else {
            return nil
        }
        return destination.logFileURL
    }

    static func debug(_ message: Any,
                      file: String = #file,
                      function: String = #function,
                      line: Int = #line) {
        #if DEBUG
        log.debug(message, file: file, function: function, line: line)
        #endif
    }

    static func info(_ message: Any,
                     file: String = #file,
                     function: String = #function,
                     line: Int = #line) {
        log.info(message, file: file, function: function, line: line)
    }

    static func warning(_ message: Any,
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line) {
        log.warning(message, file: file, function: function, line: line)
    }

    static func error(_ message: Any,
                      file: String = #file,
                      function: String = #function,
                      line: Int = #line) {
        log.error(message, file: file, function: function, line: line)
        #if DEBUG
        assertionFailure(String(describing: message))
        #endif
    }
}

private final class CustomConsoleDestination: BaseDestination {

    override var defaultHashValue: Int { return 1 }

    override init() {
        super.init()
        format = loggingFormat
    }

    override func send(_ level: SwiftyBeaver.Level,
                       msg: String,
                       thread: String,
                       file: String,
                       function: String,
                       line: Int,
                       context: Any? = nil) -> String? {
        let formattedString = super.send(level,
                                         msg: msg,
                                         thread: thread,
                                         file: file,
                                         function: function,
                                         line: line,
                                         context: context)

        if let str = formattedString {
            print(str)
        }
        return formattedString
    }
}
