import Foundation
import UIKit

class RegistrationViewController: BaseViewController<RegistrationViewModel> {
    
    // MARK: - Outlets
    
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            usernameTextField.setMainTextFieldSettings()
            usernameTextField.keyboardType = .namePhonePad
        }
    }
    
    @IBOutlet weak var ageTextField: UITextField! {
        didSet {
            ageTextField.setMainTextFieldSettings()
            usernameTextField.keyboardType = .decimalPad
        }
    }
    
    @IBOutlet weak var genderTextField: UITextField! {
        didSet {
            genderTextField.setMainTextFieldSettings()
        }
    }
    
    @IBOutlet weak var applyButton: UIButton! {
        didSet {
            applyButton.setOrangeButtonSettings()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func applyButtonPressed() {
        
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
    
//    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.setNavigationBarHidden(false, animated: false)
//    }
}
