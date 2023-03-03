//
//  SceneDelegate.swift
//  image-search-task
//
//  Created by inae Lee on 2023/02/28.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let imageSearchRepository = SearchRepository()
        let bookmarkRepository = BookmarkRepository()

        let imageSearchViewModel = ImageSearchViewModel(
            imageSearchUseCase: ImageSearchUseCase(searchRespository: imageSearchRepository),
            bookmarkUseCase: BookmarkUseCase(bookmarkRepository: bookmarkRepository)
        )
        let imageSearchViewController = ImageSearchViewController(imageSearchViewModel)
        imageSearchViewController.view.backgroundColor = .white

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = imageSearchViewController
        window?.makeKeyAndVisible()
    }
}
