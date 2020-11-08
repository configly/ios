//
//  File.swift
//  
//
//  Created by Jeremy Smith on 11/7/20.
//

import Foundation

struct ValuePayload<T>: Decodable where T: Decodable {
    enum ValueType: String, Decodable {
        case jsonBlob, string, number, boolean
    }
    let ttl: Int
    let type: ValueType
    let value: T
}
struct KeyValue<T>: Decodable where T: Decodable {
    let data: [String: ValuePayload<T>]
    let missingKeys: [String]
}
