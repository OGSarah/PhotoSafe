//
//  SceneDelegate.swift
//  PhotoSafe
//
//  Created by Sarah Clark on 7/24/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let photoGalleryViewController = PhotoGalleryViewController()
        let navigationController = UINavigationController(rootViewController: photoGalleryViewController)
        window.rootViewController = navigationController
        self.window = window
        // MakeKeyAndVisible is a convenience method to show the current window and position in front of all other windows at the same level or lower.
        window.makeKeyAndVisible()
    }

}
