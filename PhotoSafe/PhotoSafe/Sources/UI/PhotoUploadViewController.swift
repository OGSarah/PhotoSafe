//
//  PhotoUploadViewController.swift
//  PhotoSafe
//
//  Created by Sarah Clark on 7/25/25.
//

import Photos
import UIKit

class PhotoUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let imageView = UIImageView()
    private let selectButton = UIButton(type: .system)
    private let saveButton = UIButton(type: .system)
    private let progressLabel = UILabel()
    private let uploadService: UploadService

    init() {
        // Initialize without public key
        uploadService = UploadService()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }

    // MARK: - Load View
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure UI
        view.backgroundColor = .white
        title = "Upload Photo"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))

        // Setup image view
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        // Setup buttons
        selectButton.setTitle("Select Photo", for: .normal)
        selectButton.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectButton)

        saveButton.setTitle("Save Photo", for: .normal)
        saveButton.addTarget(self, action: #selector(savePhoto), for: .touchUpInside)
        saveButton.isEnabled = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)

        // Setup progress label
        progressLabel.text = "Select a photo to upload"
        progressLabel.textAlignment = .center
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressLabel)

        // Constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 300),

            selectButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            saveButton.topAnchor.constraint(equalTo: selectButton.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            progressLabel.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            progressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    // MARK: - Actions
    @objc private func selectPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }

    @objc private func savePhoto() {
        guard let image = imageView.image,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            progressLabel.text = "No image selected"
            return
        }

        progressLabel.text = "Encrypting and saving..."
        saveButton.isEnabled = false

        // Save asynchronously
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let id = UUID().uuidString
            let tags = "default" // Placeholder; integrate face detection later
            self?.uploadService.uploadPhoto(imageData: imageData, id: id, tags: tags, title: nil)

            DispatchQueue.main.async {
                self?.progressLabel.text = "Photo saved!"
                self?.saveButton.isEnabled = true
                // Dismiss after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    @objc private func cancelAction() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            saveButton.isEnabled = true
            progressLabel.text = "Ready to save"
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: UI Preview
#Preview {
    let viewController = PhotoUploadViewController()
    return viewController
}
