import XCTest
@testable import configly

var count = 0;
func counter(e: XCTestExpectation) {
    count += 1;
    if count >= 3 {
        e.fulfill()
    }
}
struct CustomObject: Decodable {
    var currency: String
    var amount: Int
    var items: [String]
}

final class configlyTests: XCTestCase {
    let client = CNGClient.setup(withApiKey: "Dem0apiKEY", options: {
        var opts = CNGOptions()
        //opts.baseUrlScheme = "http"
        //opts.baseUrlHost = "localhost:3000"
        opts.baseHostUrl = URL(string:"http://localhost:3000")!
        return opts
    }());

    func testGetNonExistingKey() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")

        client.bool(forKey: "doesnt_exist") { (error, value) -> () in
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
        client.string(forKey: "marketing_splash") { (error, value) -> () in
             print(String(format:"Worked! %@ -> %@", "marketing_splash", value ?? "none"))
            expectation.fulfill();

         };
        wait(for: [expectation], timeout: 5.0)
    }

    func testGetBool() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        client.bool(forKey: "should_i_eat_arepa") { (error, value) -> () in
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
        client.integer(forKey: "num_arepas_to_eat") { (error, value) -> () in
            print(String(format:"Worked! %@ -> \(value!)", "num_arepas_to_eat"))
            expectation.fulfill();
        };
        wait(for: [expectation], timeout: 5.0)
    }
    func testGetDouble() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        client.double(forKey: "percent-eaten-pizza") { (error, value) -> () in
            print(String(format:"Worked! %@ -> \(value!)", "percent-eaten-pizza"))
            expectation.fulfill();
        };
        wait(for: [expectation], timeout: 5.0)
    }
    func testGetStringArray() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        client.stringArray(forKey: "best_videogames") { (error, value) -> () in
            print(String(format:"Worked! %@ -> \(value!)", "best_videogames"))
            expectation.fulfill();
        };
        wait(for: [expectation], timeout: 5.0)
    }
    func testGetStringDictionary() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        client.stringDictionary(forKey: "color_styles") { (error, value) -> () in
            print(String(format:"Worked! %@ -> \(value!)", "best_videogames"))
            expectation.fulfill();
        };
        wait(for: [expectation], timeout: 5.0)
    }
    func testGetCustomObject() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        client.object(forKey: "pricing_info") { (error, value: CustomObject?) -> () in
            print(String(format:"Worked! %@ -> \(value!)", "pricing_info"))
            expectation.fulfill();
        };
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCachingGetString() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        client.string(forKey: "marketing_splash") { (error, value) -> () in
             print(String(format:"Worked! %@ -> %@", "marketing_splash", value ?? "none"))
            sleep(0)
            self.client.string(forKey: "marketing_splash") { (error, value) -> () in
                print(String(format:"2 Worked! %@ -> %@", "marketing_splash", value ?? "none"))
                expectation.fulfill();

            }
        }

        wait(for: [expectation], timeout: 10.0)
    }
    static var allTests = [
        ("testGetNonExistingKey", testGetNonExistingKey),
        ("testGetString", testGetString),
        ("testGetBool", testGetBool),
        ("testGetDouble", testGetBool),
    ]
}
