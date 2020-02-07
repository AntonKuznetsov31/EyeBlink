import UIKit

extension UIButton {

    func setOrangeButtonSettings() {
        self.layer.borderColor = #colorLiteral(red: 0.9419986606, green: 0.942250669, blue: 0.5674133301, alpha: 1)
        self.layer.borderWidth = 4
        self.layer.cornerRadius = 25
        self.clipsToBounds = true
        self.layer.shadowColor = #colorLiteral(red: 0.51505512, green: 0.4815355539, blue: 0.2079870701, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
    }
    
}
