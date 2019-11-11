//
//  AppDelegate.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 11/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let disposeBag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let rootViewController = ViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        Networking()
            .getExpenses(limit: 10, offset: 0)
            .subscribe(
                onSuccess: { (expenses) in
                    print("Success")
            },
                onError: { error in
                    print("Error: \(error)")
            })
            .disposed(by: disposeBag)
        
        return true
    }
    
}
