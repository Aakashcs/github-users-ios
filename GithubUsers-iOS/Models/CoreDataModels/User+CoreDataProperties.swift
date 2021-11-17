//
//  User+CoreDataProperties.swift
//  GithubUsers-iOS
//
//  Created by Aakash on 14/11/2021.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var avatarUrl: String?
    @NSManaged public var blog: String?
    @NSManaged public var company: String?
    @NSManaged public var followers: Int32
    @NSManaged public var following: Int32
    @NSManaged public var id: Int32
    @NSManaged public var username: String?
    @NSManaged public var bio: String?
    @NSManaged public var name: String?
    @NSManaged public var nodeId: String?

}

extension User : Identifiable {

}
