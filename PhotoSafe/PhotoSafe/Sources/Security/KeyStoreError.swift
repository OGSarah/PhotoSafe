//
//  KeyStoreError.swift
//  PhotoSafe
//
//  Created by Sarah Clark on 7/24/25.
//

import Foundation

struct KeyStoreError: Error, CustomStringConvertible {

    var message: String

    init(_ message: String) {
        self.message = message
    }

    public var description: String {
        return message
    }

}

extension OSStatus {

    // A human-readable message for the status.
    var message: String {
        return (SecCopyErrorMessageString(self, nil) as String?) ?? String(self)
    }

}
