//
//  Note+CoreDataProperties.swift
//  GithubUsers-iOS
//
//  Created by Aakash on 14/11/2021.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var note: String?
    @NSManaged public var userId: Int32
    
   
}

extension Note : Identifiable {

}
