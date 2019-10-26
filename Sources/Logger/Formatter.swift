//
//  File.swift
//  
//
//  Created by Maddie Schipper on 10/25/19.
//

import Foundation

public protocol Formatter {
    func format(message: Message) throws -> String
}

public struct ValueFormatter : Formatter {
    public func format(message: Message) throws -> String {
        return message.value
    }
}


@available(OSX 10.12, iOS 10.0, *)
public struct MetaFormatter : Formatter {
    private let formatter: ISO8601DateFormatter = {
        let fmt = ISO8601DateFormatter()
        fmt.timeZone = TimeZone(abbreviation: "GMT")
        return fmt
    }()
    
    public func format(message: Message) throws -> String {
        return "\(self.formatter.string(from: message.sentAt)) [\(message.level)] \(message.value)"
    }
}
