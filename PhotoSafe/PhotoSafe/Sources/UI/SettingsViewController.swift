//
//  SettingsViewController.swift
//  PhotoSafe
//
//  Created by Sarah Clark on 7/25/25.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView: UITableView

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
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Clear Cache"
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
                // Placeholder: Clear cache logic
                print("Clear cache tapped")
            case 1:
                // Placeholder: Show encryption settings
                print("Encryption settings tapped")
            default:
                break
        }
    }

}

// MARK: UI Preview
#Preview {
    let viewController = SettingsViewController()
    return viewController
}
