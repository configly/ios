import XCTest
@testable import configly

final class configlyTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(configly().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
