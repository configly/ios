//
//  Client.swift
//
//
//  Created by Configly on 11/5/20.
//
import Foundation

public struct CNGOptions {
    var baseHostUrl = URL(string:"https://api.config.ly")!
    var timeout = 3000
    var disableCache = false
}

public struct CNGError {
    var status: String;
    var message: String;
    var originalError: Error?;
}

public typealias CNGCallback<T> = (CNGError?, T?) -> ()
public class CNGClient {
    private static var VERSION = "1.0"

    private var apiKey: String = "";
    private var baseUrlScheme: String = "";

    private var baseHostUrl: URL = URL(string:"https://api.config.ly")!;
    private var timeout: Int = 0;
    private var disableCache: Bool = false;
    private var initialized: Bool = false;

    private static var instance: CNGClient = CNGClient();


    public static func setup(withApiKey: String, options: CNGOptions?) -> CNGClient {
        var opts = options;
        if (options == nil) {
            opts = CNGOptions();
        }
        CNGClient.instance.apiKey = withApiKey;
        CNGClient.instance.timeout = opts!.timeout
        CNGClient.instance.disableCache = opts!.disableCache
        CNGClient.instance.baseHostUrl = opts!.baseHostUrl
        CNGClient.instance.initialized = true

        return CNGClient.instance;
    }

    public static func shared() -> CNGClient {
        return CNGClient.instance;
    }

    private func getRequestForGet(keys: [String]) -> URLRequest {
        // Construct URL
        var components = URLComponents(url: self.baseHostUrl, resolvingAgainstBaseURL: false)!
        components.path = "/api/v1/value"
        components.queryItems = keys.map { URLQueryItem(name: "keys[]", value: $0) }

        // Construct Request
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue(String(format: "configly-ios/%@", CNGClient.VERSION), forHTTPHeaderField: "user-agent")

        // Auth
        let auth = String(format: "%@:", self.apiKey).data(using: String.Encoding.utf8)!
        let base64Auth = auth.base64EncodedString()
        request.setValue("Basic \(base64Auth)", forHTTPHeaderField: "Authorization")

        return request
    }

    private func httpRequestForGetKey<T>(forKey: String, callback: @escaping CNGCallback<T>) where T: Decodable {
        let request = self.getRequestForGet(keys:[forKey])
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else {
                callback(CNGError(status:"OTHER", message:"Data object was empty", originalError: nil), nil);
                return;
            }
            do {
                //print("DATA: %@", String(data: data, encoding:.utf8))
                let keyValue: KeyValue = try JSONDecoder().decode(KeyValue<T>.self, from:data)

                // Return nil if the value isn't found.
                if keyValue.data[forKey] == nil {
                    callback(nil, nil);
                    return;
                }

                callback(nil, keyValue.data[forKey]!.value)

            } catch {
                callback(CNGError(status:"PARSE_ERROR", message:"Error parsing JSON response. Are you sure the value stored in Configly matches the Swift type?", originalError: error), nil);
                return;
            }
        }

        task.resume()
    }

    public func string(forKey: String, callback: @escaping CNGCallback<String>) {
        httpRequestForGetKey(forKey: forKey, callback: callback);
    }

    public func bool(forKey: String, callback: @escaping CNGCallback<Bool>) {
        httpRequestForGetKey(forKey: forKey, callback: callback);
    }
    public func double(forKey: String, callback: @escaping CNGCallback<Double>) {
        httpRequestForGetKey(forKey: forKey, callback: callback);
    }
    public func integer(forKey: String, callback: @escaping CNGCallback<Int>) {
        httpRequestForGetKey(forKey: forKey, callback: callback);
    }

    public func stringArray(forKey: String, callback: @escaping CNGCallback<[String]>) {
        httpRequestForGetKey(forKey: forKey, callback: callback);
    }
    public func stringDictionary(forKey: String, callback: @escaping CNGCallback<[String:String]>) {
        httpRequestForGetKey(forKey: forKey, callback: callback);
    }
    public func object<T>(forKey: String, callback: @escaping CNGCallback<T>) where T: Decodable {
        httpRequestForGetKey(forKey: forKey, callback: callback);

    }
}
