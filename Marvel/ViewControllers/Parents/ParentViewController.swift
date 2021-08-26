//
//  ParentViewController.swift
//  manup
//
//  Created by iOS Development Company on 08/01/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit
import AVKit
import Photos
import NVActivityIndicatorView

@objc protocol RefreshProtocol: NSObjectProtocol{
    @objc optional func refreshController()
    @objc optional func refreshNotification(noti: Notification)
}

class ParentViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var viewNavigation: UIView?
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?
    @IBOutlet var verticalConstraints: [NSLayoutConstraint]?
    
    // MARK: - Actions
    @IBAction func parentBackAction(_ sender: UIButton!) {
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func parentBackActionAnim(_ sender: UIButton!) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func parentDismissAction(_ sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Variables for Pull to Referesh
    let refresh = UIRefreshControl()
    
    // MARK: - iOS Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        constraintUpdate()
        setDefaultUI()
        setLoaderUI()
        view.clipsToBounds = true
        kprint(items: "Allocated: \(self.classForCoder)")
    }
    
    deinit{
        _defaultCenter.removeObserver(self)
        kprint(items: "Deallocated: \(self.classForCoder)")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Set Default UI
    func setDefaultUI() {
        refresh.tintColor = AppColor.cEC1D24
        tableView?.scrollsToTop = true;
        tableView?.tableFooterView = UIView()
    }
    
    func setLoaderUI() {
        activityIndicator.hidesWhenStopped = false
        activityIndicator.isHidden = false
    }
    
    // This will update constaints and shrunk it as device screen goes lower.
    func constraintUpdate() {
        if let hConts = horizontalConstraints {
            for const in hConts {
                let v1 = const.constant
                let v2 = v1 * _widthRatio
                const.constant = v2
            }
        }
        if let vConst = verticalConstraints {
            for const in vConst {
                let v1 = const.constant
                let v2 = v1 * _heightRatio
                const.constant = v2
            }
        }
    }
    
    // MARK: - Lazy Variables
    lazy internal var activityIndicator : UIActivityIndicatorView = {
        let act = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        act.color = UIColor.white
        return act
    }()
    
    lazy internal var centralActivityIndicator : NVActivityIndicatorView = {
        let act = NVActivityIndicatorView(frame: CGRect.zero, type: NVActivityIndicatorType.lineScalePulseOut, color: AppColor.cEC1D24, padding: nil)
        return act
    }()
}


//MARK:- Uitility Methods
extension ParentViewController {
    
    // MARK: - Get Textfiled Cell    
    func tableViewCell(index: Int , section : Int = 0) -> UITableViewCell? {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: section))
        return cell
    }
    
    func scrollToIndex(index: Int, animate: Bool = false) {
        if index >= 0 {
            tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: UITableView.ScrollPosition.none, animated: animate)
        }
    }
    
    func scrollToIndexChat(section: Int, index: Int, animate: Bool = false){
        if index >= 0{
            tableView.scrollToRow(at: IndexPath(row: index, section: section), at: UITableView.ScrollPosition.top, animated: animate)
        }
    }
    
    func scrollToTop(animate: Bool = false) {
        let point = CGPoint(x: 0, y: -tableView.contentInset.top)
        tableView.setContentOffset(point, animated: animate)
    }
    
    func scrollToBottom(animate: Bool = false)  {
        let point = CGPoint(x: 0, y: tableView.contentSize.height + tableView.contentInset.bottom - tableView.frame.height)
        if point.y >= 0{
            tableView.setContentOffset(point, animated: animate)
        }
    }
    
    func customPresentationTransition() {
        let transition = CATransition()
        transition.duration = _vcTransitionTime
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        view.window?.layer.add(transition, forKey: kCATransition)
    }
}

//MARK:- Activity Indicator
extension ParentViewController{
    
    // This will show and hide spinner. In middle of container View
    // You can pass any view here, Spinner will be placed there runtime and removed on hide.
    func showSpinnerIn(container: UIView, control: UIButton, isCenter: Bool, spinnerColor: UIColor = .white) {
        activityIndicator.color = spinnerColor
        container.addSubview(activityIndicator)
        let xConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: container, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: container, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([xConstraint, yConstraint])
        activityIndicator.alpha = 0.0
        view.layoutIfNeeded()
        self.view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.2) { () -> Void in
            self.activityIndicator.alpha = 1.0
            if isCenter{
                control.alpha = 0.0
            }
        }
    }
    
    func hideSpinnerIn(container: UIView, control: UIButton) {
        self.view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
        control.isSelected = false
        UIView.animate(withDuration: 0.2) { () -> Void in
            self.activityIndicator.alpha = 0.0
            control.alpha = 1.0
        }
    }
    
    func showCentralSpinner() {
        self.view.addSubview(centralActivityIndicator)
        let xConstraint = NSLayoutConstraint(item: centralActivityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: centralActivityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let hei = NSLayoutConstraint(item: centralActivityIndicator, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 40)
        let wid = NSLayoutConstraint(item: centralActivityIndicator, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 40)
        centralActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([xConstraint, yConstraint, hei, wid])
        centralActivityIndicator.alpha = 0.0
        self.view.layoutIfNeeded()
        self.view.isUserInteractionEnabled = false
        centralActivityIndicator.startAnimating()
        UIView.animate(withDuration: 0.2) { () -> Void in
            self.centralActivityIndicator.alpha = 1.0
        }
    }
    
    func hideCentralSpinner() {
        self.view.isUserInteractionEnabled = true
        centralActivityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.2) { () -> Void in
            self.centralActivityIndicator.alpha = 0.0
        }
    }
}


// MARK: - Validation Message.
extension ParentViewController {
    
    /// Present totast view for some seconds if error occured in api call.
    ///
    /// - Parameters:
    ///   - data: Json error responce
    ///   - view: view in which you want to display error, if nil then toast displayed in window.
    ///   - yCord: YCordinate of totast view, if not passed then display after navigation bar.
    func showError(data: Any?, view: UIView? = nil, yCord: CGFloat = _statusBarHeight) {
        if let dict = data as? NSDictionary{
            if let msg = dict["message"] as? String{
                _ = ValidationToast.showStatusMessage(message: msg, yCord: yCord, inView: view)
            } else if let msg = dict["messages"] as? String{
                _ = ValidationToast.showStatusMessage(message: msg, yCord: yCord, inView: view)
            } else if let msg = dict["error"] as? String{
                _ = ValidationToast.showStatusMessage(message: msg, yCord: yCord, inView: view)
            } else if let msg = dict[_appName] as? String {
                if msg != kInternetDown {
                    _ = ValidationToast.showStatusMessage(message: msg, yCord: yCord, inView: view)
                }
            } else {
                _ = ValidationToast.showStatusMessage(message: kInternalError, yCord: yCord, inView: view)
            }
        } else {
            _ = ValidationToast.showStatusMessage(message: kInternalError, yCord: yCord, inView: view)
        }
    }
    
    /// Present totast view for some seconds if any success message available in api call.
    ///
    /// - Parameters:
    ///   - data: Json error responce
    ///   - view: view in which you want to display error, if nil then toast displayed in window.
    ///   - yCord: YCordinate of totast view, if not passed then display after navigation bar.
    func showSuccessMsg(data: Any?, view: UIView? = nil, yCord: CGFloat = _navigationHeight) {
        if let dict = data as? NSDictionary{
            if let msg = dict["message"] as? String{
                _ = ValidationToast.showStatusMessage(message: msg,yCord: yCord, inView: view, withColor: AppColor.successToastColor)
            }else if let msg = dict["error"] as? String{
                _ = ValidationToast.showStatusMessage(message: msg, yCord: yCord, inView: view, withColor: AppColor.successToastColor)
            }else if let msg = dict["success"] as? String{
                _ = ValidationToast.showStatusMessage(message: msg, yCord: yCord, inView: view, withColor: AppColor.successToastColor)
            }else if let msg = dict[_appName] as? String {
                if msg != kInternetDown {
                    _ = ValidationToast.showStatusMessage(message: msg, yCord: yCord, inView: view, withColor: AppColor.successToastColor)
                }
            }else{
                _ = ValidationToast.showStatusMessage(message: kInternalError, yCord: yCord, inView: view, withColor: AppColor.successToastColor)
            }
        }else{
            _ = ValidationToast.showStatusMessage(message: kInternalError, yCord: yCord, inView: view, withColor: AppColor.successToastColor)
        }
    }
}

// MARK: - Camera and Photo library permission
extension ParentViewController {
    
    typealias PermissionStatus = (_ status: Int, _ isGranted: Bool) -> ()
    
    func cameraAccess(permissionWithStatus block: @escaping PermissionStatus) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .authorized:
                block(AVAuthorizationStatus.authorized.rawValue, true)
            case .denied:
                block(AVAuthorizationStatus.denied.rawValue, false)
                self.showAccessPopup(title: kCameraAccessTitle, msg: kCameraAccessMsg)
            case .restricted:
                block(AVAuthorizationStatus.restricted.rawValue, false)
                self.showAccessPopup(title: kCameraAccessTitle, msg: kCameraAccessMsg)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (grant) in
                    DispatchQueue.main.async {
                        if grant {
                            block(AVAuthorizationStatus.authorized.rawValue, grant)
                        }else{
                            self.showAccessPopup(title: kCameraAccessTitle, msg: kCameraAccessMsg)
                            block(AVAuthorizationStatus.denied.rawValue, grant)
                        }
                    }
                })
            }
        }else{
            showAccessPopup(title: kCameraAccessTitle, msg: kCameraAccessMsg)
            block(AVAuthorizationStatus.restricted.rawValue, false)
        }
    }
    
    func showAccessPopup(title: String?, msg: String?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func photoLibraryAccess(block: @escaping PermissionStatus) {
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            block(status.rawValue, true)
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (perStatus) in
                DispatchQueue.main.async {
                    if perStatus == PHAuthorizationStatus.authorized {
                        block(perStatus.rawValue, true)
                    } else {
                        self.showAccessPopup(title: kPhotosAccessTitle, msg: kPhotosAccessMsg)
                        block(perStatus.rawValue, false)
                    }
                }
            }
        } else {
            self.showAccessPopup(title: kPhotosAccessTitle, msg: kPhotosAccessMsg)
            block(status.rawValue, false)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
