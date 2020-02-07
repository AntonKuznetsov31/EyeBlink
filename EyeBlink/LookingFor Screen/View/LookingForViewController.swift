import UIKit

class LookingForViewController: BaseViewController<LookingForViewModel>, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    enum PickerType {
        case gender, location, age
        
        func values() -> [String] {
            switch self {
            case .gender:
                return ["Male", "Female", "Other"]
            case .location:
                return ["Neighbourhood", "Anywhere"]
            case .age:
                return ["10","20","30","40","50","60","70","80","90"]
            }
        }
        
        func componentsAmount() -> Int {
            return self == .age ? 2 : 1
        }
    }
    
    struct AgeRange {
        var fromAge = "10"
        var toAge = "10"
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var genderTextField: UITextField! {
        didSet {
            genderTextField.setMainTextFieldSettings()
            genderTextField.delegate = self
            genderTextField.inputView = pickerView
        }
    }
    
    @IBOutlet weak var ageRangeTextField: UITextField! {
        didSet {
            ageRangeTextField.setMainTextFieldSettings()
            ageRangeTextField.delegate = self
            ageRangeTextField.inputView = pickerView
        }
    }
    
    @IBOutlet weak var locationTextField: UITextField! {
        didSet {
            locationTextField.setMainTextFieldSettings()
            locationTextField.delegate = self
            locationTextField.inputView = pickerView
        }
    }
    
    @IBOutlet weak var okButton: UIButton! {
        didSet {
            okButton.setOrangeButtonSettings()
        }
    }
    
    var pickerView = UIPickerView()
    var ageRange = AgeRange()
    // MARK: - Actions
    
    @IBAction func nextButtonPressed() {
        
    }
    
    private var pickerState: PickerType = .age
    
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
        return pickerState.componentsAmount()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerState.values().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerState.values()[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textAlignment = .center
        
        label.text = pickerState.values()[row]
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerState {
        case .age:
            
            switch component {
            case 0:
                ageRange.fromAge = pickerState.values()[row]
                
            case 1:
                ageRange.toAge = pickerState.values()[row]
            default:
                return
            }
        
            ageRangeTextField.text = "\(ageRange.fromAge) - \(ageRange.toAge)"
            
        case .gender:
            genderTextField.text = pickerState.values()[row]
        case .location:
            locationTextField.text = pickerState.values()[row]
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 101:
            pickerState = .gender
            pickerView.reloadAllComponents()
            return true
        case 102:
            pickerState = .age
            pickerView.reloadAllComponents()
            return true
        case 103:
            pickerState = .location
            pickerView.reloadAllComponents()
            return true
        default:
            return false
        }
    }
}
