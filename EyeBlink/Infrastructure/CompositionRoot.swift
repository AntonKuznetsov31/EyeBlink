//
//  CompositionRoot.swift
//  MVVMtest
//
//  Created by Daria on 27.01.2020.
//  Copyright © 2020 Anton Kuznetsov. All rights reserved.
//

import UIKit

class CompositionRoot {
    
    // MARK: - Properties
    
    static var sharedInstance: CompositionRoot = CompositionRoot()
    
    var rootTabBarController: UITabBarController!
    
    // MARK: - Initializer
    
    required init() {
        configureRootTabBarController()
    }
    
    // MARK: - Methods
    
    func configureRootTabBarController() {
        rootTabBarController = UITabBarController()
        rootTabBarController.tabBar.isTranslucent = false
    }
    
    func resolveUserMessageViewController() -> UserMessageViewController {
        let userMessageVC = UserMessageViewController.instantiateFromStoryboard("Message")
        userMessageVC.viewModel = resolveUserMessageViewModel()
        return userMessageVC
    }
    
    func resolveResultViewController(result: String) -> ResultViewController {
        let resultVC = ResultViewController.instantiateFromStoryboard("Result")
        resultVC.viewModel = resolveResultViewModel(result: result)
        return resultVC
    }
    
    // MARK: - ViewModel Resolve
    
    func resolveUserMessageViewModel() -> UserMessageViewModel {
        return UserMessageViewModel()
    }
    
    func resolveResultViewModel(result: String) -> ResultViewModel {
        return ResultViewModel(result: result)
    }
}
