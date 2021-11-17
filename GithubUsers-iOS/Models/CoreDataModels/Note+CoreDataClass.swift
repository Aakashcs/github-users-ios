//
//  Note+CoreDataClass.swift
//  GithubUsers-iOS
//
//  Created by Aakash on 14/11/2021.
//
//

import Foundation
import CoreData

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}


@objc(Note)
public class Note: NSManagedObject, Codable {
  
    enum CodingKeys: String, CodingKey {
           case note
           case userId
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(note, forKey: .note)
        try container.encode(userId, forKey: .userId)
    }
    
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(context: CoreDataManager.shared.persistentContainer.viewContext)
        
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        userId = try values.decodeIfPresent(Int32.self, forKey: .userId) ?? 0
      }
}
