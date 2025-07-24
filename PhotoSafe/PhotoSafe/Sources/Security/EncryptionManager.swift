//
//  SecurityService.swift
//  PhotoSafe
//
//  Created by Sarah Clark on 7/24/25.
//

import CryptoKit
import Foundation

class EncryptionManager {

    /// Encrypts photo data for a recipient using their XWingMLKEM768X25519 public key (quantum-secure HPKE)
    /// - Parameters:
    ///   - data: The plaintext photo data to encrypt
    ///   - recipientPublicKey: The recipient's XWingMLKEM768X25519 public key
    ///   - info: Optional context info (default empty)
    ///   - authenticatedMetadata: Optional associated data (default empty)
    /// - Throws: Errors from HPKE or CryptoKit
    /// - Returns: A tuple containing the encapsulation and the AES-GCM encrypted ciphertext
    func encryptPhotoFile(_ data: Data, recipientPublicKey: XWingMLKEM768X25519.PublicKey, info: Data = Data(), authenticatedMetadata: Data = Data()) throws -> (encapsulation: Data, ciphertext: Data) {
        // Choose the HPKE ciphersuite that uses XWingMLKEM768X25519 for quantum-resistant KEM,
        // SHA-256 for HKDF, and AES-GCM-256 for AEAD encryption.
        let ciphersuite = HPKE.Ciphersuite.XWingMLKEM768X25519_SHA256_AES_GCM_256

        // Create an HPKE Sender context that binds the encryption to the recipient's public key,
        // the chosen ciphersuite, and optional context info.
        // This context handles the hybrid KEM encryption process.
        var sender = try HPKE.Sender(recipientKey: recipientPublicKey, ciphersuite: ciphersuite, info: info)

        // Get the encapsulation data (encapsulated key) that the recipient must receive to decrypt.
        let encapsulation = sender.encapsulatedKey

        // Encrypt the plaintext data under the HPKE context and authenticate any additional metadata.
        // This produces the ciphertext protected by AEAD with associated data authentication.
        let ciphertext = try sender.seal(data, authenticating: authenticatedMetadata)

        // Return a tuple containing the encapsulation and the encrypted ciphertext,
        // so the recipient can use both to decrypt and verify the data.
        return (encapsulation: encapsulation, ciphertext: ciphertext)
    }

    /// Decrypts photo data using the recipient's XWingMLKEM768X25519 private key (quantum-secure HPKE)
    /// - Parameters:
    ///   - encapsulation: The encapsulation bytes
    ///   - ciphertext: The AES-GCM encrypted photo data
    ///   - recipientPrivateKey: The recipient's XWingMLKEM768X25519 private key
    ///   - info: Optional context info (default empty)
    ///   - authenticatedMetadata: Optional associated data (default empty)
    /// - Throws: Errors from HPKE or CryptoKit
    /// - Returns: The decrypted photo data
    func decryptPhotoFile(encapsulation: Data, ciphertext: Data, recipientPrivateKey: XWingMLKEM768X25519.PrivateKey, info: Data = Data(), authenticatedMetadata: Data = Data()) throws -> Data {
        // Use the same HPKE ciphersuite as encryption; must match exactly for successful decryption.
        let ciphersuite = HPKE.Ciphersuite.XWingMLKEM768X25519_SHA256_AES_GCM_256

        // Reconstruct the HPKE Recipient context for decryption.
        // This binds to the recipient's private key, ciphersuite, context info, and the received encapsulation.
        var recipient = try HPKE.Recipient(privateKey: recipientPrivateKey, ciphersuite: ciphersuite, info: info, encapsulatedKey: encapsulation)

        // Open (decrypt and verify) the ciphertext using the context,
        // authenticating the additional metadata to ensure integrity and authenticity.
        let plaintext = try recipient.open(ciphertext, authenticating: authenticatedMetadata)

        // Return the decrypted plaintext photo data.
        return plaintext
    }

}
