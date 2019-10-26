//
//  Message.swift
//  
//
//  Created by Maddie Schipper on 10/25/19.
//

import Foundation

public struct Message {
    public let value: String
    public let sentAt: Date
    public let level: Level
    
    internal init(_ value: String, _ sentAt: Date, _ level: Level) {
        self.value = value
        self.sentAt = sentAt
        self.level = level
    }
}
