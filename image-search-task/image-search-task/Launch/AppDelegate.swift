//
//  AppDelegate.swift
//  image-search-task
//
//  Created by inae Lee on 2023/02/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        guard #unavailable(iOS 13) else { return true }

        let imageSearchRepository = SearchRepository()
        let bookmarkRepository = BookmarkRepository()

        let imageSearchViewModel = ImageSearchViewModel(
            imageSearchUseCase: ImageSearchUseCase(searchRespository: imageSearchRepository),
            bookmarkUseCase: BookmarkUseCase(bookmarkRepository: bookmarkRepository)
        )
        let imageSearchViewController = ImageSearchViewController(imageSearchViewModel)
        imageSearchViewController.view.backgroundColor = .red

        window = UIWindow()
        window?.rootViewController = imageSearchViewController
        window?.makeKeyAndVisible()

        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}
}
