import UIKit

class LookingForViewController: BaseViewController<LookingForViewModel> {
    
    // MARK: - Outlets
    
    @IBOutlet weak var genderTextField: UITextField! {
        didSet {
            genderTextField.setMainTextFieldSettings()
        }
    }
    
    @IBOutlet weak var ageRangeTextField: UITextField! {
        didSet {
            ageRangeTextField.setMainTextFieldSettings()
        }
    }
    
    @IBOutlet weak var locationTextField: UITextField! {
        didSet {
            locationTextField.setMainTextFieldSettings()
        }
    }
    
    @IBOutlet weak var okButton: UIButton! {
        didSet {
            okButton.setOrangeButtonSettings()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonPressed() {
        
    }
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        self.setGradientBackground()
        self.hidingKeyboardSettings()
        
        createDayPicker()
        createToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func createDayPicker() {
        
        let dayPicker = UIPickerView()
        dayPicker.delegate = self
        
        ageRangeTextField.inputView = dayPicker
        
        //Customizations
//        dayPicker.backgroundColor = .black
    }
    
    
    func createToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        //Customizations
//        toolBar.barTintColor = .black
//        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(LookingForViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        ageRangeTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LookingForViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.genderArray[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ageRangeTextField.text = viewModel.genderArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        var label: UILabel

        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }

//        label.textColor = .green
        label.textAlignment = .center
//        label.font = UIFont(name: "Menlo-Regular", size: 17)

        label.text = viewModel.genderArray[row]

        return label
    }
}
