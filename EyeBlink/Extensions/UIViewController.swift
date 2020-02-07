import UIKit

extension UIViewController {
    
    class func instantiateFromStoryboard(_ name: String = "Registration") -> Self {
        return instantiateFromStoryboardHelper(name)
    }
    
    fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let identifier = String(describing: self)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier) as! T
        return controller
    }
    
    func setGradientBackground() {
        let colorTop =  #colorLiteral(red: 1, green: 0.9989046454, blue: 0.3976633549, alpha: 1).cgColor
        let colorBottom = #colorLiteral(red: 1, green: 0.8252578974, blue: 0.03597186506, alpha: 1).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [colorTop, colorBottom]
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func hidingKeyboardSettings() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
}
