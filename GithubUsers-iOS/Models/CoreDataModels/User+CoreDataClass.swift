//
//  User+CoreDataClass.swift
//  GithubUsers-iOS
//
//  Created by Aakash on 14/11/2021.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case bio = "bio"
        case blog = "blog"
        case company = "company"
        case followers = "followers"
        case following = "following"
        case id = "id"
        case name = "name"
        case username = "login"
        case nodeId = "node_id"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(avatarUrl, forKey: .avatarUrl)
        try container.encode(bio, forKey: .bio)
        try container.encode(blog, forKey: .blog)
        try container.encode(company, forKey: .company)
        try container.encode(followers, forKey: .followers)
        try container.encode(following, forKey: .following)
        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(name, forKey: .name)
        try container.encode(nodeId, forKey: .nodeId)
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(context: CoreDataManager.shared.persistentContainer.viewContext)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        avatarUrl = try values.decodeIfPresent(String.self, forKey: .avatarUrl)
        bio = try values.decodeIfPresent(String.self, forKey: .bio)
        blog = try values.decodeIfPresent(String.self, forKey: .blog)
        company = try values.decodeIfPresent(String.self, forKey: .company)
        followers = try values.decodeIfPresent(Int32.self, forKey: .followers) ?? 0
        following = try values.decodeIfPresent(Int32.self, forKey: .following) ?? 0
        id = try values.decodeIfPresent(Int32.self, forKey: .id) ?? 0
        username = try values.decodeIfPresent(String.self, forKey: .username)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        nodeId = try values.decodeIfPresent(String.self, forKey: .nodeId)
    }
}
