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


