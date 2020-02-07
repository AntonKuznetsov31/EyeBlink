import Foundation

class LookingForViewModel: ViewModel {
    
    
//    let genderArray = ["Male", "Female", "Other"]
//
//    let location = ["Neighbourhood", "Anywhere"]
//
//    let age = ["10","20","30","40","50","60","70","80","90"]
    
    enum pickerViewType {
        
        case gender
        case location
        case age
        
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
    }
    
}
