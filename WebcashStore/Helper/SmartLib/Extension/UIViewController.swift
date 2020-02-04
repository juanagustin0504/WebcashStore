import UIKit
import SafariServices

extension UIViewController: SFSafariViewControllerDelegate {
    
    static var storyboardIdentifier : String {
        String(describing: self)
    }
    
    private func canOpenURL(_ string: String?) -> Bool {
        guard let urlString = string, let url = URL(string: urlString) else {
            return false
        }
        
        if !UIApplication.shared.canOpenURL(url) { return false }
        
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
    
    func openUrl(url: String) {
        if !canOpenURL(url) {
            return
        }
        
        if let url = URL(string: url) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self
            if #available(iOS 10.0, *) {
                vc.preferredBarTintColor        = .white
                vc.preferredControlTintColor    = .black
            }
            present(vc, animated: true)
        }
    }
    
    func openWebURL(url : String, comletion: ((Bool) -> Void)? = nil) {
        let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        guard let appUrl = URL(string: encoded) else { return }
        if UIApplication.shared.canOpenURL(appUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appUrl, options: [:], completionHandler: comletion)
            } else {
                let _ = UIApplication.shared.openURL(appUrl)
                if let whenOpened = comletion { whenOpened(true) }
            }
        }
    }
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
//        dismiss(animated: true)
    }
    
    func openSafari(url : String) {
        let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        guard let appUrl = URL(string: encoded) else { return }
        
        if UIApplication.shared.canOpenURL(appUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appUrl, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appUrl)
            }
        }
    }
    
    func closeAppWithoutLookingLikeCrash() {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            exit(EXIT_SUCCESS)
        })
    }
    
    func ableToSwipeNavigationBack() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func disableToSwipeNavigationBack() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func clearConstraintLog() {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
    
    func presentVC(viewController: UIViewController, animated: Bool = true, completion: @escaping Completion = { }) {
        self.present(viewController, animated: animated) {
            completion()
        }
    }
    
    func presentVC(sbName: String, identifier: String, animated: Bool = true, completion: @escaping Completion = { }) {
        self.present(VC(sbName: sbName, identifier: identifier), animated: animated) {
            completion()
        }
    }
    
    func pushVC(viewController: UIViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func pushVC(sbName: String, identifier: String, animated: Bool = true) {
        self.navigationController?.pushViewController(VC(sbName: sbName, identifier: identifier), animated: animated)
    }
    
    func popOrDismissVC(animated: Bool = true, completion: @escaping Completion = { }) {
        if let nav = self.navigationController {
            nav.popViewController(animated: animated)
            completion()
        }
        else {
            self.dismiss(animated: animated) {
                completion()
            }
        }
    }
    
    func VC(sbName: String, identifier: String) -> UIViewController {
        return UIStoryboard(name: sbName, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    func navController(sbName: String, identifier: String) -> UINavigationController {
        return UIStoryboard(name: sbName, bundle: nil).instantiateViewController(withIdentifier: identifier) as! UINavigationController
    }
    
    func removePreviousVC(withNumberOfViewContollerNeedToRollback numberOfVC: Int) {
        // Remove last stack of navigationController
        if let navigationController = self.navigationController {
            var navigationArray = navigationController.viewControllers  // To get all UIViewController stack as Array
            navigationArray.remove(at: navigationArray.count - numberOfVC) // To remove previous UIViewController
            self.navigationController?.viewControllers = navigationArray
        }
    }
    
    // Important
    func setRootViewController(sbName: String, identifier: String, direction: UIWindow.TransitionOptions.Direction = .fade, duration: TimeInterval = 0.3) {
        let window              = UIApplication.shared.keyWindow
        var animateOption       = UIWindow.TransitionOptions()
        animateOption.direction = direction
        animateOption.duration  = duration
        window?.setRootViewController(VC(sbName: sbName, identifier: identifier), options: animateOption)
    }
    
    // Important
    func setRootViewController(viewController: UIViewController, direction: UIWindow.TransitionOptions.Direction = .fade, duration: TimeInterval = 0.3) {
        let window              = UIApplication.shared.keyWindow
        var animateOption       = UIWindow.TransitionOptions()
        animateOption.direction = direction
        animateOption.duration  = duration
        window?.setRootViewController(viewController, options: animateOption)
    }
    
    // Important
    func setRootNavViewController(sbName: String, identifier: String, direction: UIWindow.TransitionOptions.Direction = .fade, duration: TimeInterval = 0.3) {
        let window              = UIApplication.shared.keyWindow
        var animateOption       = UIWindow.TransitionOptions()
        animateOption.direction = direction
        animateOption.duration  = duration
        window?.setRootViewController(navController(sbName: sbName, identifier: identifier), options: animateOption)
    }
    
    // Important
    func setRootNavViewController(navigation: UINavigationController, direction: UIWindow.TransitionOptions.Direction = .fade, duration: TimeInterval = 0.3) {
        let window              = UIApplication.shared.keyWindow
        var animateOption       = UIWindow.TransitionOptions()
        animateOption.direction = direction
        animateOption.duration  = duration
        window?.setRootViewController(navigation, options: animateOption)
    }
    
    func setTheme(barTint: UIColor = .white, tint: UIColor = .black) {
        view.backgroundColor                                    = barTint
        navigationController?.navigationBar.barTintColor        = barTint
        navigationController?.navigationBar.tintColor           = tint
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: tint]
        navigationController?.navigationBar.isTranslucent       = false
        navigationController?.navigationBar.removeShadow()
    }
    
    func alert(title: String = "안내", message: String, okbtn: String = "확인", completion: @escaping Completion = { }) {
        if let jsonData = message.data(using: String.Encoding.utf8) {
            do {
                try JSONSerialization.jsonObject(with: jsonData)
                alertJsonError(title: title, message: message)
            }
            catch {
                let alert   = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let ok      = UIAlertAction(title: okbtn, style: .cancel) { (_) in
                    completion()
                }
                alert.addAction(ok)
                
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func alertJsonError(title: String, message: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        let messageText = NSMutableAttributedString(
            string: message,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor : UIColor.black
            ]
        )
        
        let alert   = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok      = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.setValue(messageText, forKey: "attributedMessage")
        
        present(alert, animated: true, completion: nil)
    }
    
    func alertYesNo(title: String = "안내", message: String, nobtn: String = "아니", yesbtn: String = "확인", completion: @escaping Completion_Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(title: yesbtn, style: .default, handler: { (action) -> Void in
                DispatchQueue.main.async {
                    completion(true)
                }
            })
        )
        alert.addAction(
            UIAlertAction(title: nobtn, style: .cancel) { (action) -> Void in
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        )
        
        self.present(alert, animated: true, completion: nil)
    }
    func gotoAppSettings() {
        if #available(iOS 10.0, *) {
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    func presentPopup(vc : UIViewController) {
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
}


//extension UIViewController {
//    func getCGSizeText(st: String, fontSize: CGFloat) -> CGSize {
//        let font = UIFont.systemFont(ofSize: fontSize)
//        let fontAtrr = [NSAttributedString.Key.font: font]
//        let size = (st as NSString).size(withAttributes: fontAtrr)
//        return size
//    }
//
//    /*
//     + TODO: Set Left Navigation Item
//     - param image : Your image name
//     - param action: Selector handle selection when click on left navigation
//     - param title : Your title when navigation title is not available
//     */
//    func setLeftNavigationItem(_ image:String, action:Selector, title:String, width: CGFloat) -> Void {
//
//        // Image
//        let image_nav = UIImage(named: image)
//
//        // Button
//        let leftNavBtn = UIButton()
//        leftNavBtn.setImage(image_nav, for: UIControl.State())
//        leftNavBtn.setTitle(title, for: UIControl.State())
//        leftNavBtn.titleLabel!.font = UIFont.systemFont(ofSize: 17)
//        let autoWidth = getCGSizeText(st: title, fontSize: 17).width
//        let frameBtn = CGRect(x: -16,y: 0,width: image_nav!.size.width + autoWidth, height: image_nav!.size.height)
//        leftNavBtn.frame = frameBtn
//        leftNavBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -26, bottom: 0, right: 0)
//        leftNavBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
//        leftNavBtn.contentHorizontalAlignment = .left
//        leftNavBtn.addTarget(self, action: action, for: UIControl.Event.touchUpInside)
//
//        // leftBarButtonItem
//        let leftBarButtonItem = UIBarButtonItem(customView: leftNavBtn)
//        self.navigationItem.leftBarButtonItem = leftBarButtonItem
//    }
//
//    func formatePhoneNumber(_ number : String?) -> String {
//        guard let phoneNumber = number else { return "" }
//
//        if phoneNumber.count < 9 {
//            return number ?? ""
//        }
//
//        var firstDigits = phoneNumber.substringWithRange(0, end: 3)
//        var secondDigits = phoneNumber.substringWithRange(3, end: 6)
//        var thirdDigits = phoneNumber.substringWithRange(6, end: phoneNumber.count)
//
//        if phoneNumber.count > 10 {
//
//            firstDigits = phoneNumber.substringWithRange(0, end: 3)
//            secondDigits = phoneNumber.substringWithRange(3, end: 7)
//            thirdDigits = phoneNumber.substringWithRange(7, end: phoneNumber.count)
//
//            return "\(firstDigits) - \(secondDigits) - \(thirdDigits)"
//        }
//        return "\(firstDigits) - \(secondDigits) - \(thirdDigits)"
//
//    }
//}


//
//import UserNotifications
//import Photos
//
//extension UIViewController {
//
//    func checkAllowNotificationPermission(completion: @escaping Completion_Bool) {
//        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
//                if settings.authorizationStatus != .authorized {
//                    DispatchQueue.main.async {
//                        completion(false)
//                    }
//                }
//                else {
//                    completion(true)
//                }
//            }
//        }
//    }
//
//    func checkDeniedCameraPermission(completion: @escaping Completion_Bool) {
//        if AVCaptureDevice.authorizationStatus(for: .video) == .denied {
//            DispatchQueue.main.async {
//                completion(true)
//            }
//        }
//        else {
//            DispatchQueue.main.async {
//                completion(false)
//            }
//        }
//    }
//
//    func checkAllowCameraPermission(completion: @escaping Completion_Bool) {
//        if AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
//            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) -> Void in
//                DispatchQueue.main.async {
//                    completion(granted)
//                }
//            })
//        }
//        else {
//            DispatchQueue.main.async {
//                completion(true)
//            }
//        }
//    }
//
//    func checkDeniedPhotoPermission(completion: @escaping Completion_Bool) {
//        if (PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.denied) {
//            DispatchQueue.main.async {
//                completion(true)
//            }
//        }
//        else {
//            DispatchQueue.main.async {
//                completion(false)
//            }
//        }
//    }
//
//    func checkAllowPhotoPermission(completion: @escaping Completion_Bool) {
//        if (PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized) {
//            DispatchQueue.main.async {
//                completion(true)
//            }
//        }
//        else if (PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.notDetermined) {
//            PHPhotoLibrary.requestAuthorization({ (newStatus) in
//                if (newStatus == PHAuthorizationStatus.authorized) {
//                    DispatchQueue.main.async {
//                        completion(true)
//                    }
//                }
//                else {
//                    DispatchQueue.main.async {
//                        completion(false)
//                    }
//                }
//            })
//        }
//        else {
//            DispatchQueue.main.async {
//                completion(false)
//            }
//        }
//    }
//}
