//
//  PhotoFileManager.swift
//  PhotoSafe
//
//  Created by Sarah Clark on 7/24/25.
//

import Foundation

class PhotoStorageManager {

    func storeEncryptedPhoto(data: Data, id: String) -> String? {
        let fileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("\(id).enc")

        do {
            try data.write(to: fileURL!)
            return fileURL!.path
        } catch {
            print("Failed to store photo \(error)")
            return nil
        }
    }

    func deleteAllPhotos(completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let documentDirectory = try FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: false
                )

                let fileURLs = try FileManager.default.contentsOfDirectory(
                    at: documentDirectory,
                    includingPropertiesForKeys: nil,
                    options: [.skipsHiddenFiles]
                )

                for fileURL in fileURLs where fileURL.pathExtension == "enc" {
                    try FileManager.default.removeItem(at: fileURL)
                }

                DispatchQueue.main.async {
                    completion(.success(()))
                }

            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

}
