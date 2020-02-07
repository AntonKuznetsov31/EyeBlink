//
//  BaseViewController.swift
//  MVVMtest
//
//  Created by Daria on 27.01.2020.
//  Copyright © 2020 Anton Kuznetsov. All rights reserved.
//

import UIKit

class BaseViewController<T>: UIViewController where T: ViewModel  {
    
    // MARK: - Properties
    
    var viewModel: T!
    
    var observer = Observer()
    
    // MARK: - Methods
    
    func set(viewModel: T) {
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewWillDisappear()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }
    
    func willEnterForeground() {
        viewModel.willEnterForeground()
    }
    
    func didEnterBackground() {
        viewModel.didEnterBackground()
    }
}
