//
//  SettingsViewController.swift
//  PhotoSafe
//
//  Created by Sarah Clark on 7/25/25.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView: UITableView
    private let userFeedbackLabel = UILabel()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableView = UITableView(frame: .zero, style: .grouped)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        // Configure table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }

    // MARK: - Load View
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"

         // Configure UI
         view.backgroundColor = .white
         tableView.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(tableView)

         // Set up Auto Layout constraints
         NSLayoutConstraint.activate([
             tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
         ])
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Delete all Photos"
            case 1:
                cell.textLabel?.text = "Encryption Settings"
            default:
                break
        }
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
            case 0:
                let alert = UIAlertController(
                    title: "Delete all photos",
                    message: "This will delete all photos and their metadata. This action cannot be undone. Continue?",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) {[weak self] _ in
                self?.deletePhotos()
            })
                present(alert, animated: true, completion: nil)
                print("Delete all photos tapped")
            case 1:
                // Placeholder: Show encryption settings
                print("Encryption settings tapped")
            default:
                break
        }
    }

    // MARK: - Private functions
    private func deletePhotos() {
        userFeedbackLabel.text = "Deleting all photos..."

        let photoDataManager = PhotoCoreDataManager()
        let photoStorageManager = PhotoStorageManager()

        // Delete files first, then Core Data to ensure consistency
        photoStorageManager.deleteAllPhotos { [weak self] storageResult in
            guard let self = self else { return }

            switch storageResult {
            case .success:
                photoDataManager.deleteAllPhotos { dataResult in
                    DispatchQueue.main.async {
                        switch dataResult {
                        case .success:
                            self.userFeedbackLabel.text = "Photos deleted successfully"
                            // Clear label after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.userFeedbackLabel.text = ""
                            }
                        case .failure(let error):
                            self.userFeedbackLabel.text = "Failed to delete all photos: \(error.localizedDescription)"
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.userFeedbackLabel.text = "Failed to delete all photos: \(error.localizedDescription)"
                }
            }
        }
    }

}

// MARK: UI Preview
#Preview {
    let viewController = SettingsViewController()
    return viewController
}
