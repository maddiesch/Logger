//
//  Logger.swift
//
//
//  Created by Maddie Schipper on 10/25/19.
//

import Foundation

public enum Level : UInt8, CustomStringConvertible {
    case trace = 0
    case debug = 1
    case info = 2
    case warn = 3
    case error = 4
    
    public var description: String {
        switch self {
        case .trace:
            return "trace"
        case .debug:
            return "debug"
        case .info:
            return "info"
        case .warn:
            return "warn"
        case .error:
            return "error"
        }
    }
}

public final class Logger {
    public static let shared = Logger()
    
    private let queue = DispatchQueue(label: "dev.schipper.Logger")
    
    
    private var _formatter: Formatter = {
        if #available(OSX 10.12, iOS 10.0, *) {
            return MetaFormatter()
        } else {
            return ValueFormatter()
        }
    }()
    public var formatter: Formatter {
        get {
            self.queue.sync { _formatter }
        }
        set {
            self.queue.sync {
                _formatter = newValue
            }
        }
    }
    
    private var _destination: Destination = ConsoleDestination()
    public var destination: Destination {
        get {
            self.queue.sync { _destination }
        }
    }
    
    public func setDestination(_ destination: Destination) throws {
        try self.queue.sync {
            try destination.open()
            try _destination.close()
            _destination = destination
        }
    }
    
    #if DEBUG
        private var _level: Level = .debug
    #else
        private var _level: Level = .info
    #endif
    
    public var level: Level {
        get {
            self.queue.sync { _level }
        }
        
        set {
            self.queue.sync { _level = newValue }
        }
    }
    
    private func loggable(_ level: Level) -> Bool {
        return self.queue.sync { _loggable(level) }
    }
    
    private func _loggable(_ level: Level) -> Bool {
        return level.rawValue >= _level.rawValue
    }
    
    public func log(level: Level, items: [Any]) {
        if !loggable(level) {
            return
        }
        
        var strings: Array<String> = []
        
        for item in items {
            switch item {
            case let str as String:
                strings.append(str)
            case let sstr as Substring:
                strings.append(String(sstr))
            case let conv as CustomStringConvertible:
                strings.append(conv.description)
            case let dconv as CustomDebugStringConvertible:
                strings.append(dconv.debugDescription)
            default:
                strings.append("\(item)")
            }
        }
        
        do {
            try self.queue.sync {
                let message = Message(strings.joined(separator: " "), Date(), level)
                
                let value = try _formatter.format(message: message)
                
                try _destination.write(message: value)
            }
        } catch {
            print("Failed to write log message:", error)
        }
    }
}

public func Trace(_ items: Any...) {
    Logger.shared.log(level: .trace, items: items)
}

public func Debug(_ items: Any...) {
    Logger.shared.log(level: .debug, items: items)
}

public func Info(_ items: Any...) {
    Logger.shared.log(level: .info, items: items)
}

public func Warn(_ items: Any...) {
    Logger.shared.log(level: .warn, items: items)
}

public func Error(_ items: Any...) {
    Logger.shared.log(level: .error, items: items)
}
