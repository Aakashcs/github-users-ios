//
//  CoreDataManager.swift
//  GithubUsers-iOS
//
//  Created by Aakash on 13/11/2021.
//

import CoreData


// Implement single of core data manager
class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    /// private constructor so that no one can make its object. only access shared object.
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "GithubUsers")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteAllUsers() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: User.fetchRequest())
        _ = try? persistentContainer.viewContext.execute(deleteRequest)
    }
    
    // Fetch the entity note for the user using user id.
   func getNoteForUser(_ user: User) -> Note? {
       let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
       
       let userid = "\(Int(user.id))"
       let predicate = NSPredicate(format: "userId == \(userid)")
       fetchRequest.predicate = predicate
       
       do {
           let notes = try persistentContainer.viewContext.fetch(fetchRequest)
           return notes.first
       } catch let error {
           print(error)
           return nil
       }
   }
    
    func getUsers(with note: String) -> [Note] {
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        
        let predicate = NSPredicate(format: "note LIKE[cd] %@", note)
        fetchRequest.predicate = predicate
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print(error)
            return []
        }
    }
}
