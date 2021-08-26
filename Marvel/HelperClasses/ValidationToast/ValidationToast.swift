//  Created by Tom Swindell on 07/12/2015.
//  Copyright © 2015 The App Developers. All rights reserved.
//

import UIKit

class KPValidationToast {
    
    static var shared = KPValidationToast()
    
    let alertWindow: UIWindow!
    
    init() {
        if #available(iOS 13.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive || $0.activationState == .foregroundInactive}).first
            if let windowScene = windowScene as? UIWindowScene {
                alertWindow = UIWindow(windowScene: windowScene)
                alertWindow.frame = CGRect(x: 0, y: 0, width: _screenSize.width, height: 20)
            } else {
                alertWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: _screenSize.width, height: 20))
            }
        } else {
            alertWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: _screenSize.width, height: 20))
        }
        alertWindow.isUserInteractionEnabled = false
        alertWindow.rootViewController = UIViewController()
        alertWindow.backgroundColor = UIColor.clear
        alertWindow.windowLevel = UIWindow.Level.statusBar + 1
        alertWindow.makeKeyAndVisible()
    }
    
    func showToastOnStatusBar(message: String, color: UIColor = AppColor.red) -> ValidationToast {
        let toast: ValidationToast
        var height: CGFloat = 0
        if _statusBarHeight > 20 {
            toast = UINib(nibName: "ValidationToast", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! ValidationToast
            toast.setToastMessage(message: message)
            toast.animatingView.backgroundColor = color
            height = message.heightWithConstrainedWidth(width: _screenSize.width - 20, font: AppFont.fontWithName(FontType.medium, size: 13)) + (45)
        } else {
            toast = UINib(nibName: "ValidationToast", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ValidationToast
            toast.setToastMessage(message: message)
            toast.animatingView.backgroundColor = color
            height = message.heightWithConstrainedWidth(width: _screenSize.width - 20, font: AppFont.fontWithName(FontType.medium, size: 13)) + (3)
        }
        
        toast.layoutIfNeeded()
        toast.animatingViewBottomConstraint.constant = height
        toast.setToastMessage(message: message)
        toast.animatingView.backgroundColor = color
        
        alertWindow.addSubview(toast)
        
        toast.animatingViewBottomConstraint.constant = height
        var f = CGRect.zero
        f = UIScreen.main.bounds
        f.size.height = height
        f.origin = CGPoint(x: 0, y: 0)
        toast.frame = f
        
        toast.layoutIfNeeded()
        toast.animateIn(duration: 0.2, delay: 0.2, completion: { () -> () in
            toast.animateOutWith(height: height,duration: 0.2, delay: 1.5, completion: { () -> () in
                toast.removeFromSuperview()
            })
        })
        return toast
    }
    
    func showStatusMessageForInterNet(message: String, withColor color: UIColor = AppColor.red) -> ValidationToast {
        let toast: ValidationToast
        var height: CGFloat = 0
        if _statusBarHeight > 20 {
            toast = UINib(nibName: "ValidationToast", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! ValidationToast
            toast.setToastMessage(message: message)
            toast.animatingView.backgroundColor = color
            height = 63
        } else {
            toast = UINib(nibName: "ValidationToast", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ValidationToast
            toast.setToastMessage(message: message)
            toast.animatingView.backgroundColor = color
            height = _statusBarHeight
        }
        
        alertWindow.addSubview(toast)
        toast.animatingViewBottomConstraint.constant = height
        var f = CGRect.zero
        f = UIScreen.main.bounds
        f.size.height = height
        f.origin = CGPoint(x: 0, y: 0)
        toast.frame = f
        toast.layoutIfNeeded()
        toast.animateIn(duration: 0.2, delay: 0.2, completion: { () -> () in
        })
        return toast
    }
}

class ValidationToast: UIView {

    // MARK:- Button Action
    @IBAction func btnTap (sender: UIButton){
        self.tapCompletions?(self)
    }
    
    // MARK: - Outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var animatingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var animatingView: UIView!
    
    // MARK:- Variables
    var tapCompletions: ((ValidationToast)->())?
    
    // MARK: - Initialisers
    
    // This will show alert message on status bar.
    @discardableResult
    class func showStatusMessage(message: String, yCord: CGFloat = _statusBarHeight, inView view: UIView? = nil, withColor color: UIColor = AppColor.red, comp: ((ValidationToast) -> ())? = nil) -> ValidationToast {
        let toast = UINib(nibName: "ValidationToast", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ValidationToast
        let strHeight = message.heightWithConstrainedWidth(width: _screenSize.width - 20, font: AppFont.fontWithName(FontType.medium, size: 13)) + (10 * _widthRatio)
        toast.layoutIfNeeded()
        toast.animatingViewBottomConstraint.constant = strHeight//28 * _widthRatio
        toast.setToastMessage(message: message)
        toast.animatingView.backgroundColor = color
        var f = CGRect.zero
        if let vw = view {
            vw.addSubview(toast)
            f = vw.frame
        } else {
            _appDelegator.window?.addSubview(toast)
            f = UIScreen.main.bounds
        }
        f.size.height = strHeight
        f.origin = CGPoint(x: 0, y: yCord)
        toast.frame = f
        toast.animateIn(duration: 0.2, delay: 0.2, completion: { () -> () in
            toast.animateOutWith(height: strHeight,duration: 0.2, delay: 1.5, completion: { () -> () in
                toast.removeFromSuperview()
                comp?(toast)
            })
        })
        return toast
    }
    
    // MARK: - Toast Functions
    func setToastMessage(message: String) {
        let font = AppFont.fontWithName(FontType.medium, size: 13)
        let color = UIColor.white
        let mutableString = NSMutableAttributedString(string: message)
        let range = NSMakeRange(0, message.count)
        mutableString.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        messageLabel.attributedText = mutableString
    }
    
    func animateIn(duration: TimeInterval, delay: TimeInterval, completion: (() -> ())?) {
        animatingViewBottomConstraint.constant = 0
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
            self.layoutIfNeeded()
            }) { (completed) -> Void in
                completion?()
        }
    }
    
    func animateOut(duration: TimeInterval, delay: TimeInterval, completion: (() -> ())?) {
        animatingViewBottomConstraint.constant = 44
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
            self.layoutIfNeeded()
            }) { (completed) -> Void in
                completion?()
        }
    }
    
    func animateOutWith(height: CGFloat, duration: TimeInterval, delay: TimeInterval, completion: (() -> ())?) {
        animatingViewBottomConstraint.constant = height
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
            self.layoutIfNeeded()
        }) { (completed) -> Void in
            completion?()
        }
    }
}
