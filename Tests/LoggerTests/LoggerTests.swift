import XCTest
@testable import Logger

final class LoggerTests: XCTestCase {
    func testLog() {
        Info(1.0, 1, "Testing")
    }
}
