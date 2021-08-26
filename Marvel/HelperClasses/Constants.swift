import UIKit
import Foundation
import AdSupport

let _screenFrame    = UIScreen.main.bounds
let _screenSize     = _screenFrame.size
let _width          = _screenSize.width
let _height         = _screenSize.height
let _defaultCenter  = NotificationCenter.default
let _userDefault    = UserDefaults.standard
let _appDelegator   = UIApplication.shared.delegate! as! AppDelegate
let _navigationHeight : CGFloat = _statusBarHeight + 44
let _customNavHeight : CGFloat = _statusBarHeight + 69
let _maxImageSize     : CGSize  = CGSize(width: 1000, height: 1000)
let _minImageSize     : CGSize  = CGSize(width: 800, height: 800)
let _vcTransitionTime = 0.3
// Constants related marvel APIs
let _marvelPublicKey: String = "d385f9f6bf1ed303b762d8fdd2166ada"
let _marvelPrivateKey: String = "22a64da5249ee8119d8efc6b1eb97e25e9409410"
let _timeStamp: String = Date().timeIntervalSince1970.description
let _marvelHash: String = "\(_timeStamp)\(_marvelPrivateKey)\(_marvelPublicKey)".md5()
// Placeholders
let _userPlaceholder = UIImage(named: "ic_user_placeholder")!
let _placeholder = UIImage(named: "ic_placeholder")!

/*---------------------------------------------------
 MARK: Paging Structure
 ---------------------------------------------------*/
struct LoadMore {
    
    var index: Int = 1
    var isLoading: Bool = false
    var limit: Int
    var isAllLoaded = false
    var lastTime: String?
    
    init(lmt: Int = 20) {
        limit = lmt
    }
    
    var offset: Int {
        return index * (limit - 1)
    }
}


/*---------------------------------------------------
 Date Formatter and number formatter
 ---------------------------------------------------*/
let _serverFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    // ((5*60) + 30) * 60 = 330 * 60 Means GMT 5:30
    df.timeZone = TimeZone(secondsFromGMT: 0)
    df.locale = Locale(identifier: "en_US_POSIX")
    return df
}()

let _deviceFormatter: DateFormatter = {
    let df = DateFormatter()
    df.timeZone = TimeZone.current
    df.locale = Locale(identifier: "en_US_POSIX")
    df.dateFormat = "MM-dd-yyyy"
    return df
}()

let _currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
//    formatter.locale = Locale.current
    formatter.locale = Locale(identifier: "fr_FR")
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    return formatter
}()


/*---------------------------------------------------
 Custom print
 ---------------------------------------------------*/
func kprint(items: Any...) {
    #if DEBUG
        for item in items {
            print(item)
        }
    #endif
}

/*---------------------------------------------------
 Device Extention
 ---------------------------------------------------*/
extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            return false
        }
    }
}


//MARK:- Constant
//--------------------------------------------------------------------------
// Common
//--------------------------------------------------------------------------
var _statusBarHeight: CGFloat = {
    if #available(iOS 11.0, *) {
        if UIDevice.current.hasNotch {
            return _appDelegator.window!.safeAreaInsets.top
        } else {
            return 20
        }
    } else {
        return 20
    }
}()

var _bottomBarHeight: CGFloat = {
    if #available(iOS 11.0, *) {
        if UIDevice.current.hasNotch {
            return _appDelegator.window!.safeAreaInsets.bottom
        } else {
            return 0
        }
    } else {
        return 0
    }
}()
