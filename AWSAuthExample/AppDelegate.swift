//
//  AppDelegate.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 3/26/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import AWSCore
import AWSLambda

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AppearanceManager.styleApp()
        application.registerForRemoteNotifications()
        let loadingViewController = LoadingViewController()
        let navigationController = UINavigationController(rootViewController: loadingViewController)
        navigationController.isNavigationBarHidden = true
        let cognitoWrapper = setupCredentials()
        AuthenticationFlowController.createShared(with: navigationController, and: cognitoWrapper)
        let window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
    
    private func setupCredentials() -> CognitoWrapper {
        guard let authenticationConstants = AuthenticationConstants() else {
            fatalError("Default AWSConstants plist is missing or malformed")
        }
        return CognitoWrapper.setupShared(with: authenticationConstants)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let _ = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        // TODO: Send off token to backend
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // TODO: Log error
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // TODO: Add PN handling
    }
}

