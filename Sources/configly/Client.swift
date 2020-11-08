//
//  Client.swift
//  
//
//  Created by Configly on 11/5/20.
//
import Foundation

struct CNGOptions {
    var baseUrlHost = "api.config.ly"
    var baseUrlScheme = "https"
    var timeout = 3000
    var disableCache = false
}
struct CNGError {
    var status: String;
    var message: String;
    var originalError: Error?;
}

typealias CNGCallback<T> = (CNGError?, T?) -> ()

class CNGClient {
    private static var VERSION = "1.0"

    private var apiKey: String = "";
    private var baseUrlScheme: String = "";

    private var baseUrlHost: String = "";
    private var timeout: Int = 0;
    private var disableCache: Bool = false;
    private var initialized: Bool = false;
    
    private static var instance: CNGClient = CNGClient();


    public static func setup(apiKey: String, options: CNGOptions = CNGOptions()) -> CNGClient {
        
        CNGClient.instance.apiKey = apiKey;
        CNGClient.instance.timeout = options.timeout
        CNGClient.instance.disableCache = options.disableCache
        CNGClient.instance.baseUrlHost = options.baseUrlHost
        CNGClient.instance.baseUrlScheme = options.baseUrlScheme
        CNGClient.instance.initialized = true
        
        return CNGClient.instance;
    }
    
    public static func shared() -> CNGClient {
        return CNGClient.instance;
    }

    private func getRequestForGet(keys: [String]) -> URLRequest {
        // Construct URL
        var components = URLComponents()
        components.scheme = self.baseUrlScheme
        components.host = self.baseUrlHost
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
    
    private func httpRequestForGetKey<T>(key: String, callback: @escaping CNGCallback<T>) where T: Decodable {
        let request = self.getRequestForGet(keys:[key])
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else {
                callback(CNGError(status:"OTHER", message:"Data object was empty", originalError: nil), nil);
                return;
            }
            do {
                print("DATA: %@", String(data: data, encoding:.utf8))
                let keyValue: KeyValue = try JSONDecoder().decode(KeyValue<T>.self, from:data)
                
                // Return nil if the value isn't found.
                if keyValue.data[key] == nil {
                    callback(nil, nil);
                    return;
                }
                
                callback(nil, keyValue.data[key]!.value)

            } catch {
                callback(CNGError(status:"OTHER", message:"Error parsing JSON response. Please try again later.", originalError: error), nil);
                return;
            }
        }

        task.resume()
    }

    public func getString(key: String, callback: @escaping CNGCallback<String>) {
        httpRequestForGetKey(key: key, callback: callback);
    }

    public func getBool(key: String, callback: @escaping CNGCallback<Bool>) {
        httpRequestForGetKey(key: key, callback: callback);
    }
    public func getDouble(key: String, callback: @escaping CNGCallback<Double>) {
        httpRequestForGetKey(key: key, callback: callback);
    }
    public func getInt(key: String, callback: @escaping CNGCallback<Int>) {
        httpRequestForGetKey(key: key, callback: callback);
    }
    /*
    public func getStringArray(key: String, callback: ((_: [String]) -> Void)) {
        httpRequestForGetKey(key: key, callback: callback);
    }

    public func getStringDictionary(key: String, callback: ((_: [String:String]) -> Void)) {
        httpRequestForGetKey(key: key, callback: callback);
    }
  */
    public func getRawJsonString(key: String, callback: ((_: String) -> Void)) {
        
    }
}
