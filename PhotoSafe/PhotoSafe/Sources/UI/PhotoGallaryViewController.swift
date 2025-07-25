//
//  PhotoGallaryViewController.swift
//  PhotoSafe
//
//  Created by Sarah Clark on 7/25/25.
//

import CoreData
import CryptoKit
import UIKit

class PhotoGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {

    private let collectionView: UICollectionView
    private let fetchedResultsController: NSFetchedResultsController<Photo>
    private let addPhotoButton: UIBarButtonItem

    init() {
        // Set up collection view layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        // Set up fetch results controller
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        addPhotoButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

        super.init(nibName: nil, bundle: nil)

        // Configure delegates
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchedResultsController.delegate = self
        addPhotoButton.target = self
        addPhotoButton.action = #selector(addPhoto)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }

    // MARK: - Load View
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure UI
        view.backgroundColor = .white
        title = "Photosafe"
        navigationItem.rightBarButtonItem = addPhotoButton

        // Set up collection view
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        // Fetch data
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch photos: \(error)")
        }

        // Add settings button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(showSettings))
    }

    // MARK: - Actions
    @objc private func addPhoto() {
        let uploadViewController = PhotoUploadViewController()
        let navigationController = UINavigationController(rootViewController: uploadViewController)
        present(navigationController, animated: true, completion: nil)
    }

    @objc private func showSettings() {
        let settingsViewController = SettingsViewController()
        navigationController?.pushViewController(settingsViewController, animated: true)
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = fetchedResultsController.object(at: indexPath)

        // Load image asynchronously
        DispatchQueue.global(qos: .userInitiated).async {
            if let image = self.loadImage(for: photo) {
                DispatchQueue.main.async {
                    cell.configure(with: image)
                }
            }
        }
        return cell
    }

    // MARK: - NSFetchedResultsControllerDelegate
    @nonobjc func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
    }

    // MARK: - Helper
    private func loadImage(for photo: Photo) -> UIImage? {
        guard let filePath = photo.filePath,
              let encapsulation = photo.value(forKey: "encapsulation") as? Data,
              let encryptedData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            return nil
        }

        guard let privateKeyData = try? KeychainHelper.shared.loadPrivateKey() else {
            print("Failed to load recipient's private key")
            return nil
        }
        // Convert Data to XWingMLKEM768X25519.PrivateKey
        let recipientPrivateKey: XWingMLKEM768X25519.PrivateKey
        do {
            recipientPrivateKey = try XWingMLKEM768X25519.PrivateKey(integrityCheckedRepresentation: privateKeyData)
        } catch {
            print("Failed to decode recipient's private key: \(error)")
            return nil
        }
        do {
            let decryptedData = try EncryptionManager().decryptPhotoFile(encapsulation: encapsulation, ciphertext: encryptedData, recipientPrivateKey: recipientPrivateKey)
            return UIImage(data: decryptedData)
        } catch {
            print("Decryption failed: \(error)")
            return nil
        }
    }
}

// Stub for KeychainHelper for private key retrieval
class KeychainHelper {
    static let shared = KeychainHelper()

    func loadPrivateKey() throws -> Data {
        // Stub implementation: Returns the raw private key bytes suitable for constructing a XWingMLKEM768X25519.PrivateKey
        throw NSError(domain: "com.photosafe.keychain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Private key not implemented"])
    }
}

#Preview {
    let viewController = PhotoGalleryViewController()
    return viewController
}
