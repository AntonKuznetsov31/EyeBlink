//
//  Coordinator.swift
//  MVVMtest
//
//  Created by Daria on 27.01.2020.
//  Copyright © 2020 Anton Kuznetsov. All rights reserved.
//

import UIKit

class Coordinator {
    
    static let shared = Coordinator()
    
    // MARK: - Private properties
    
    private var lastPresentedViewController: UIViewController?
    
    private var baseNavigationController: UINavigationController? {
        return lastPresentedViewController?.navigationController
    }
    
    private var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    private var compositionRoot: CompositionRoot {
        return CompositionRoot.sharedInstance
    }
    
    // MARK: - Methods
    
    func push(_ vc: UIViewController) {
        if let baseNavigationController = baseNavigationController {
            baseNavigationController.pushViewController(vc, animated: true)
            lastPresentedViewController = vc
        } else {
            if let navigationController = appDelegate.window?.rootViewController as? UINavigationController {
                navigationController.pushViewController(vc, animated: true)
            }
        }
    }
    
    func setNavigationsetViewController(_ vc: UIViewController) {
        if let baseNavigationController = baseNavigationController {
            baseNavigationController.setViewControllers([vc], animated: true)
            lastPresentedViewController = vc
        } else {
            if let navigationController = appDelegate.window?.rootViewController as? UINavigationController {
                navigationController.setViewControllers([vc], animated: true)
            }
        }
    }
}
