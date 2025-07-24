//
//  SecurityService.swift
//  PhotoSafe
//
//  Created by Sarah Clark on 7/24/25.
//

import Foundation

class SecurityService {

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

}
