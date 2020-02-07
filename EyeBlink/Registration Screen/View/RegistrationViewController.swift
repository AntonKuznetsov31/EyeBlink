import Foundation
import UIKit

class RegistrationViewController: BaseViewController<RegistrationViewModel>, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let genderArray = ["Male", "Female", "Other"]
    
    // MARK: - Outlets
    
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            usernameTextField.setMainTextFieldSettings()
            usernameTextField.keyboardType = .alphabet
            usernameTextField.autocapitalizationType = .words
        }
    }
    
    @IBOutlet weak var ageTextField: UITextField! {
        didSet {
            ageTextField.setMainTextFieldSettings()
            ageTextField.keyboardType = .decimalPad
        }
    }
    
    @IBOutlet weak var genderTextField: UITextField! {
        didSet {
            genderTextField.setMainTextFieldSettings()
            genderTextField.delegate = self
            genderTextField.inputView = pickerView
        }
    }
    
    @IBOutlet weak var applyButton: UIButton! {
        didSet {
            applyButton.setOrangeButtonSettings()
        }
    }
    
    var pickerView = UIPickerView()
    
    // MARK: - Actions
    
    @IBAction func applyButtonPressed() {
        
    }
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        self.setGradientBackground()
        self.hidingKeyboardSettings()
        pickerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - UIPickerView Delegate and DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textAlignment = .center
        
        label.text = genderArray[row]
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        genderTextField.text = genderArray[row]
    }
}
