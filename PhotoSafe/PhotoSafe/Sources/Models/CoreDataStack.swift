//
//  CoreDataStack.swift
//  PhotoSafe
//
//  Created by Sarah Clark on 7/24/25.
//

import CoreData

class CoreDataStack {

    // Singleton for easy access
    static let shared = CoreDataStack()

    // Persistent container
    private let persistentContainer: NSPersistentContainer

    // Main context (used on the main thread)
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private init() {
        // Initialize with the data model name.
        persistentContainer = NSPersistentContainer(name: "PhotoSafe")

        // Configure the SQLite store.
        let description = NSPersistentStoreDescription()
        description.type = NSSQLiteStoreType
        description.url = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("PhotoSafe.sqlite")

        // Load Persistent stores
        persistentContainer.loadPersistentStores{_, error in
            if let error = error as NSError? {
                fatalError("Failed to load Core Data store: \(error), \(error.userInfo)")
            }
        }

        // Enable automatic merging of changes from background contexts
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    // Background context for async operations
    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }

    func saveMainContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let saveContextError = error as NSError
                print("Failed to save main context: \(saveContextError), \(saveContextError.userInfo)")
            }
        }
    }

    func saveBackgroundContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let saveContextError = error as NSError
                print("Failed to save background context \(saveContextError), \(saveContextError.userInfo)")
            }
        }
    }

}
