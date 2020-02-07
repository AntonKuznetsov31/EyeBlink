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
    
    // MARK: - Resolve ViewController
    
    func resolveRegistrationViewController() -> RegistrationViewController {
        let registrationVC = RegistrationViewController.instantiateFromStoryboard("Registration")
        registrationVC.viewModel = resolveRegistrationViewModel()
        return registrationVC
    }
    
    func resolveLookingForViewController() -> LookingForViewController {
        let lookingForVC = LookingForViewController.instantiateFromStoryboard("LookingFor")
        lookingForVC.viewModel = resolveLookingForViewModel()
        return lookingForVC
    }
    
    // MARK: - Resolve ViewModel
    
    func resolveRegistrationViewModel() -> RegistrationViewModel {
        return RegistrationViewModel()
    }
    
    func resolveLookingForViewModel() -> LookingForViewModel {
        return LookingForViewModel()
    }
    
    
    
}
