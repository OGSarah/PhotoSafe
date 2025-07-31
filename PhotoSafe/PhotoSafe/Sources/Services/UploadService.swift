//
//  PhotoUploadService.swift
//  PhotoSafe
//
//  Created by Sarah Clark on 7/24/25.
//

import Foundation

class UploadService {

    private let photoCoreDataManager = PhotoCoreDataManager()
    private let fileStorageManager = PhotoStorageManager()
    private let encryptionManager = EncryptionManager()

    func uploadPhoto(imageData: Data, id: String, tags: String, title: String?) {

    }

}
