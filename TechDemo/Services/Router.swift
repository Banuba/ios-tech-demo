//
//  Router.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 22.03.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

import Foundation

final class Router {
    private var mainViewModel: MainScreenViewModel!
    
    func routeToMainScreen(in window: UIWindow) {
        let storyboard = UIStoryboard(name: String(describing: MainViewController.self), bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! MainViewController
        mainViewModel = MainScreenViewModel(view: viewController)
        viewController.viewModel = mainViewModel
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    func handleDeepLink(_ url: URL) {
        guard let route = DeepLinkParser.deepLinkRoute(from: url) else { return }
        mainViewModel.handleDeepLinkRoute(route)
    }
}
