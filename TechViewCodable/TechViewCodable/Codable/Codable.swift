//
//  Codable.swift
//  TechViewCodable
//
//  Created by jhunter on 2018/8/28.
//  Copyright © 2018 J.Hunter. All rights reserved.
//

import Foundation

protocol CodableProtocol: Codable {
    
    
}

extension CodableProtocol {
    
    private var encoder: JSONEncoder { return JSONEncoder() }
    
    public var dic: Dictionary<String, Any>? {
        return (try? jsonDic()) ?? nil
    }
    
    /// Model ---> Dic
    func jsonDic(options opt: JSONSerialization.ReadingOptions = .allowFragments) throws -> Dictionary<String, Any>? {
        
        let data = try encoder.encode(self)
        return try JSONSerialization.jsonObject(with: data, options: opt) as? Dictionary<String, Any>
    }
    
    /// Model ---> Data
    func jsonData() throws -> Data {
        return try encoder.encode(self)
    }
    
    /// Model ---> JSONString
    func jsonStr() throws -> String? {
        
        let data = try encoder.encode(self)
        return String(data: data, encoding: .utf8)
    }
    
}


extension CodableProtocol {
    
    static private var decoder: JSONDecoder { return JSONDecoder() }
    
    /// Dic ---> Model
    static func initialization(_ dic: Dictionary<String, Any>, options opt: JSONSerialization.WritingOptions = .prettyPrinted) throws -> Self {
        
        let data = try JSONSerialization.data(withJSONObject: dic, options: opt)
        return try decoder.decode(Self.self, from: data)
    }
    
    /// Data ---> Model
    static func initialization(_ data: Data) throws -> Self {
        
        return try decoder.decode(Self.self, from: data)
    }
    
    /// JSONString ---> Model
    static func initialization(_ jsonStr: String) throws -> Self? {
        
        if let data = jsonStr.data(using: .utf8) {
            return try decoder.decode(Self.self, from: data)
        }
        return nil
    }
    
}











