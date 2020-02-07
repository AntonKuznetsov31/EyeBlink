import UIKit

class SignInViewController: BaseViewController<SignInViewModel> {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.setMainTextFieldSettings()
            emailTextField.keyboardType = .emailAddress
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.setMainTextFieldSettings()
            passwordTextField.keyboardType = .asciiCapable
            passwordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.setOrangeButtonSettings()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonPressed() {
        
    }
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        self.setGradientBackground()
        self.hidingKeyboardSettings()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
