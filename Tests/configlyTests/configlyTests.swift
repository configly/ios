import XCTest
@testable import configly

var count = 0;
func counter(e: XCTestExpectation) {
    count += 1;
    if count >= 3 {
        e.fulfill()
    }
}

final class configlyTests: XCTestCase {

    func testGetNonExistingKey() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        let client = CNGClient.setup(apiKey: "Dem0apiKEY");

        client.getBool(key: "doesnt_exist") { (error, value) -> () in
            var output: String = "false"
            if (value != nil) {
                output = value! ? "true" : "false"
            } else {
                output = "not found";
            }
            print(String(format:"Worked! %@ -> %@", "doesnt_exist", output))

            expectation.fulfill();

        };
    }

    func testGetString() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        let client = CNGClient.setup(apiKey: "Dem0apiKEY");


        client.getString(key: "marketing_splash") { (error, value) -> () in
             print(String(format:"Worked! %@ -> %@", "marketing_splash", value ?? "none"))
            expectation.fulfill();

         };
        wait(for: [expectation], timeout: 5.0)
    }

    func testGetBool() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        let client = CNGClient.setup(apiKey: "Dem0apiKEY");

        client.getBool(key: "should_i_eat_arepa") { (error, value) -> () in
            var output: String = "false"
            if (value != nil) {
                output = value! ? "true" : "false"
            } else {
                output = "not found";
            }
            print(String(format:"Worked! %@ -> %@", "should_i_eat_arepa", output))
            expectation.fulfill();
        };
        wait(for: [expectation], timeout: 5.0)
    }

    func testGetInt() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        let client = CNGClient.setup(apiKey: "Dem0apiKEY");

        client.getInt(key: "num_arepas_to_eat") { (error, value) -> () in
            print(String(format:"Worked! %@ -> \(value!)", "num_arepas_to_eat"))
            expectation.fulfill();
        };
        wait(for: [expectation], timeout: 5.0)
    }
    func testGetDouble() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        let client = CNGClient.setup(apiKey: "Dem0apiKEY");

        client.getDouble(key: "percent-eaten-pizza") { (error, value) -> () in
            print(String(format:"Worked! %@ -> \(value!)", "percent-eaten-pizza"))
            expectation.fulfill();
        };
        wait(for: [expectation], timeout: 5.0)
    }
    /*
    func testGetStringArray() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        let client = CNGClient.setup(apiKey: "Dem0apiKEY");

        client.getStringArray(key: "best_videogames") { (error, value) -> () in
            print(String(format:"Worked! %@ -> \(value!)", "best_videogames"))
            expectation.fulfill();
        };
        wait(for: [expectation], timeout: 5.0)
    }
    */

    static var allTests = [
        ("testGetNonExistingKey", testGetNonExistingKey),
        ("testGetString", testGetString),
        ("testGetBool", testGetBool),
        ("testGetDouble", testGetBool),
    ]
}
