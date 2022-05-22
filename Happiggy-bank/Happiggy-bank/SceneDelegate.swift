//
//  SceneDelegate.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/09.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?
    
    
    // MARK: - Functions
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene)
        else { return }
        
        guard let errorMessage = PersistenceStore.fatalErrorDescription
        else {
            /// 정상적인 경우
            PersistenceStore.shared.windowScene = scene
            return
        }
        /// 코어데이터 에러 발생
        scene.windows.first?.rootViewController = ErrorViewController(errorMessage: errorMessage)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        VersionManager.shared.checkVersionOnAppStore { [weak self] forcedUpdateIsNeeded in
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .appStoreInfoDidLoad, object: nil)
                
                guard forcedUpdateIsNeeded
                else { return }

                self?.window?.rootViewController?.topMostViewController()?
                    .presentForceUpdateAlertIfNeeded()
            }
        }

    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        PersistenceStore.shared.save()
    }    
}
