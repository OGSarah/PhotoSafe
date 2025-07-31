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

    func deleteAllPhotos(completion: @escaping (Result<Void, Error>) -> Void) {
        let backgroundContext = coreDataStack.newBackgroundContext()

        backgroundContext.perform { [weak self] in
            guard let self = self else {
                completion(.failure(NSError(domain:"", code: -1, userInfo: [NSLocalizedDescriptionKey: "PhotoDataManager deallocated"])))
                return
            }

            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Photo.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try backgroundContext.execute(deleteRequest)
                try backgroundContext.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }

    // TODO: Add fetchPhotos function
    // TODO: Add deletePhoto function for deleting individual photos

}
