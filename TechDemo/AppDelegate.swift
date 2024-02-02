//
//  AppDelegate.swift
//  TechDemo
//
//  Created by Alexey Ereschenko on 28/08/2018.
//  Copyright © 2018 Banuba. All rights reserved.
//

import UIKit
import BNBSdkApi
import FirebaseCore
import FirebaseDynamicLinks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let router = Router()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard NSClassFromString("XCTestCase") == nil else { return true }
        FirebaseApp.configure()
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        router.routeToMainScreen(in: window)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL else {
            return false
        }
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(url) { [weak self] dynamiclink, error in
            if error == nil, let dynamiclink, dynamiclink.matchType != .none, let url = dynamiclink.url {
                self?.router.handleDeepLink(url)
            }
        }
        
        return handled
    }

    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return application(app, open: url,
                           sourceApplication: options[UIApplication.OpenURLOptionsKey
                            .sourceApplication] as? String,
                           annotation: "")
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,
                     annotation: Any) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url),
           dynamicLink.matchType != .none, let url = dynamicLink.url {
            router.handleDeepLink(url)
            return true
        }
        return false
    }
}
