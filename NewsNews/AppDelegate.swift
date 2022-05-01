//
//  AppDelegate.swift
//  NewsNews
//
//  Created by  Mr.Ki on 01.05.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let onboardingContainerViewController = OnboardingContainerViewController()
    let tabBarController = UITabBarController()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        onboardingContainerViewController.delegate = self
        
        let vc1 = ViewController()
        let vc2 = ListViewController()
      
        vc1.tabBarItem.image = UIImage(systemName: "newspaper")
        vc2.tabBarItem.image = UIImage(systemName: "paperclip")
        
        vc1.title = "News"
        vc2.title = "List"
        
        let nc1 = UINavigationController(rootViewController: vc1)
        let nc2 = UINavigationController(rootViewController: vc2)

        tabBarController.viewControllers = [nc1, nc2]
        
        checkFirstLaunch()
        
        
        return true
    }
    

    
    class ListViewController: UIViewController {
        override func viewDidLoad() {
            title = "List"
            view.backgroundColor = .green
        }
    }
   
}

extension AppDelegate {
    func checkFirstLaunch() {
        if LocalState.hasOnboarded {
            setRootViewController(tabBarController)
        } else {
            setRootViewController(onboardingContainerViewController)
            
        }
    }
}

extension AppDelegate: OnboardingContainerViewControllerDelegate {
    func didFinishOnboarding() {
        LocalState.hasOnboarded = true
        setRootViewController(tabBarController)
        
    }
}

//MARK: - Slow transition
extension AppDelegate {
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard animated, let window = self.window else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.8,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
}
