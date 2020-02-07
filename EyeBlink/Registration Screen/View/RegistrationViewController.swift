import Foundation
import UIKit

class SignUpViewController: BaseViewController<SignUpViewModel> {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nicknameTextField: UITextField! {
        didSet {
            nicknameTextField.setMainTextFieldSettings()
            nicknameTextField.keyboardType = .namePhonePad
        }
    }
    
    @IBOutlet weak var ageTextField: UITextField! {
        didSet {
            ageTextField.setMainTextFieldSettings()
            ageTextField.keyboardType = .asciiCapableNumberPad
        }
    }
    
    @IBOutlet weak var genderTextField: UITextField! {
        didSet {
            genderTextField.setMainTextFieldSettings()
        }
    }
    
    @IBOutlet weak var enterButton: UIButton! {
        didSet {
            enterButton.setOrangeButtonSettings()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func enterButtonPressed() {
        
    }
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        self.setGradientBackground()
        self.hidingKeyboardSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
