//
//  InvestorModeI.swift
//  ProjectStash
//
//  Created by Julio Reyes on 7/26/18.
//  Copyright © 2018 Julio Reyes. All rights reserved.
//

import Foundation

struct Overview : Codable
{
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
    }
}

struct Achievements : Codable
{
    let id: Int
    let level: String
    let progress: Int
    let total: Int
    let bgImageURL: String
    let accessible: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case level = "level"
        case progress = "progress"
        case total = "total"
        case bgImageURL = "bg_image_url"
        case accessible = "accessible"
    }
}

struct InvestorModel: Codable {
    let overview: Overview
    let achievements: [Achievements]
    
    enum CodingKeys: String, CodingKey {
        case overview = "overview"
        case achievements = "achievements"
    }
}

// MARK: Convenience initializers and mutators
extension InvestorModel {
    init(data: Data) throws {
        self = try JSONDecoder().decode(InvestorModel.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Achievements {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Achievements.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Overview {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Overview.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


