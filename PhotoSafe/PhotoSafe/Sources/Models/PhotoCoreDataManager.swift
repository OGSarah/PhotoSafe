//
//  PhotoDataManager.swift
//  PhotoSafe
//
//  Created by Sarah Clark on 7/24/25.
//

import CoreData

class PhotoCoreDataManager {

    private let coreDataStack = CoreDataStack.shared

    func savePhoto(id: String, filePath: String, tags: String, title: String?) {
        let backgroundContext = coreDataStack.newBackgroundContext()

        backgroundContext.perform {
            let photo = Photo(context: backgroundContext)
            photo.id = id
            photo.filePath = filePath
            photo.timestamp = Date()
            photo.tags = tags
            photo.title = title
            self.coreDataStack.saveBackgroundContext(backgroundContext)
        }
    }

    // TODO: Add fetchPhotos function
    // TODO: Add deletePhoto function

}
