//
//  Destination.swift
//  
//
//  Created by Maddie Schipper on 10/25/19.
//

import Foundation

/// Destination is the protocol that must be satisfied to write to a log location
public protocol Destination {
    /// Open is the method that is called when the logger is setup.
    /// This gives the destination time to create an resources it needs
    func open() throws
    
    /// Close is called when the logger is torn down, usually on application termination
    func close() throws
    
    /// Receives the message that should be written to the destination.
    /// - Parameter message: The log message
    func write(message: String) throws
}

public extension Destination {
    func open() throws {
    }
    
    func close() throws {
    }
}


public struct ConsoleDestination : Destination {
    public func write(message: String) throws {
        print(message)
    }
}
