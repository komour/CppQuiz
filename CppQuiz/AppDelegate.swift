//
//  AppDelegate.swift
//  CppQuiz
//
//  Created by Always Strive n Prosper on 20/10/2019.
//  Copyright © 2019 komarov. All rights reserved.
//

import UIKit

// Идея крутая, но нужно заставить её работать. Даже если это будет один хорошо работающий экран - уже замечательно
// Нужен поход в сеть и локальное хранилище.
// На главном экране происходит какая-то дичь в районе формы ответа внизу, а контролы сверху вообще ничего не делают =(
// Ланджафтный режим нужно либо заставить выглядеть приемлемо, либо отключить.

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

