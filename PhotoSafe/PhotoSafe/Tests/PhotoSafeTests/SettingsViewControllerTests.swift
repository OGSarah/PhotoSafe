//
//  SettingsViewControllerTests.swift
//  PhotoSafeTests
//
//  Created by Sarah Clark on 7/28/25.
//

@testable import PhotoSafe
import XCTest

final class SettingsViewControllerTests: XCTestCase {

    func testSettingsTableViewLoads() {
        let viewController = SettingsViewController()
        viewController.loadViewIfNeeded()

        // TODO: Fix this: [<PhotoSafe.SettingsViewController 0x10913a7b0> valueForUndefinedKey:]: this class is not key value coding-compliant for the key tableView. (NSUnknownKeyException)
        let tableView = viewController.value(forKey: "tableView") as? UITableView
        XCTAssertNotNil(tableView)
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 2)

        let firstCell = tableView?.cellForRow(at: IndexPath(row: 0, section: 0))
        let secondCell = tableView?.cellForRow(at: IndexPath(row: 1, section: 0))
        XCTAssertEqual(firstCell?.textLabel?.text, "Clear Cache")
        XCTAssertEqual(secondCell?.textLabel?.text, "Encryption Settings")
    }

}
