import UIKit

extension UINavigationBar {
    
    func removeShadow(bool: Bool = true) -> Void {
        if bool {
            self.setValue(true, forKey: "hidesShadow")
        }
        else {
            self.setValue(false, forKey: "hidesShadow")
        }
    }
}
