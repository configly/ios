import XCTest

import configlyTests

var tests = [XCTestCaseEntry]()
tests += configlyTests.allTests()
XCTMain(tests)
