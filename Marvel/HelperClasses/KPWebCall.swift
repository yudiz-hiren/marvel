//  Created by iOS Development Company on 12/12/16.
//  Copyright © 2016 iOS Development Company. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import CryptoSwift

// MARK: Web Operation
struct AccessTokenAdapter: RequestInterceptor {
    
    private let accessToken: String
    
    init(token: String) {
        accessToken = token
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var req = urlRequest
        req.headers.add(.authorization("Bearer \(accessToken)"))
        completion(.success(req))
    }
}

enum HostMode {
    case production
    case staging
    case local
    
    var isSandBoxEnable: Bool {
        return true
    }
    
    var baseUrl: String {
        switch self {
        case .production:
            return ""
        case .staging:
            return "http://gateway.marvel.com/v1/public/"
        case .local:
            return ""
        }
    }
}

enum ResponseType: String {
    case error = "error"
    case success = "success"
    case emailNotVerify = "email-warning"
    case phoneNotVerify = "phone-warning"
    case none = "none"
    
    init(str: String) {
        self = ResponseType(rawValue: str) ?? .none
    }
}

// Hosting mode
let _hostMode = HostMode.staging

typealias WSBlock = (_ json: Any?, _ flag: Int) -> ()
typealias WSProgress = (Progress) -> ()?
typealias WSFileBlock = (_ path: String?, _ error: Error?) -> ()

//fileprivate struct MarvelAPIConfig {
//    static let privatekey = _marvelPrivateKey
//    static let apikey = _marvelPublicKey
//    static let ts = Date().timeIntervalSince1970.description
//    //static let hash = "\(ts)\(privatekey)\(apikey)".md5()
//    static let hash = "\(Date.currentTimeStamp)\(_marvelPrivateKey)\(_marvelPublicKey)".md5()
//}

class WebService: NSObject {
    
    static let shared: WebService = WebService()
    
    let manager: Session
    var networkManager = NetworkReachabilityManager.default
    var headers: HTTPHeaders {
        var head = HTTPHeaders.default
        return head
    }
    var token: RequestInterceptor?
    var toast: ValidationToast!
    let timeOutInteraval: TimeInterval = 60
    var successBlock: (String, HTTPURLResponse?, AnyObject?, WSBlock) -> Void
    var errorBlock: (String, HTTPURLResponse?, NSError, WSBlock) -> Void
    var marvelAuthParameters: [String: String] {
        return ["apikey": _marvelPublicKey, "ts": _timeStamp, "hash": _marvelHash]
    }
    
    override init() {
        manager = Alamofire.Session.default
        
        // Will be called on success of web service calls.
        successBlock = { (relativePath, res, respObj, block) -> Void in
            // Check for response it should be there as it had come in success block
            if let response = res{
                kprint(items: "Response Code: \(response.statusCode)")
                kprint(items: "Response(\(relativePath)): \(String(describing: respObj))")
                if let auth = response.headers.value(for: "Authorization") {
                    WebService.shared.setAccesTokenToHeader(token: auth)
                }
                if response.statusCode == 200 {
                    block(respObj, response.statusCode)
                } else {
                    if response.statusCode == 401 {
//                        if _user != nil{
//                            Config.appDelegator.removeUserInfoAndNavToLogin()
//                            if let msg = respObj?["error"] as? String{
//                                _ = KPValidationToast.shared.showToastOnStatusBar(message: msg)
//                            }else{
//                                _ = KPValidationToast.shared.showToastOnStatusBar(message: kTokenExpire)
//                            }
//                        }
                        block([_appName: kInternetDown] as AnyObject, response.statusCode)
                    } else {
                        block(respObj, response.statusCode)
                    }
                }
            } else {
                // There might me no case this can get execute
                block(nil, 404)
            }
        }
        
        // Will be called on Error during web service call
        errorBlock = { (relativePath, res, error, block) -> Void in
            // First check for the response if found check code and make decision
            if let response = res {
                kprint(items: "Response Code: \(response.statusCode)")
                kprint(items: "Error Code: \(error.code)")
                if let data = error.userInfo["com.alamofire.serialization.response.error.data"] as? NSData {
                    let errorDict = (try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                    if errorDict != nil {
                        kprint(items: "Error(\(relativePath)): \(errorDict!)")
                        block(errorDict!, response.statusCode)
                    } else {
                        let code = response.statusCode
                        block(nil, code)
                    }
                } else if response.statusCode == 401 {
//                    if _user != nil{
//                        Config.appDelegator.removeUserInfoAndNavToLogin()
//                        _ = KPValidationToast.shared.showToastOnStatusBar(message: kTokenExpire)
//                    }
                    block([_appName: kInternetDown] as AnyObject, response.statusCode)
                }else {
                    block(nil, response.statusCode)
                }
                // If response not found rely on error code to find the issue
            } else if error.code == -1009 || error.code == 13 {
                kprint(items: "Error(\(relativePath)): \(error)")
                block([_appName: kInternetDown] as AnyObject, error.code)
                return
            } else if error.code == -1003 {
                kprint(items: "Error(\(relativePath)): \(error)")
                block([_appName: kHostDown] as AnyObject, error.code)
                return
            } else if error.code == -1001 {
                kprint(items: "Error(\(relativePath)): \(error)")
                block([_appName: kTimeOut] as AnyObject, error.code)
                return
            } else {
                kprint(items: "Error(\(relativePath)): \(error)")
                block(nil, error.code)
            }
        }
        super.init()
        addInterNetListner()
    }
    
    deinit {
        networkManager?.stopListening()
    }
}

// MARK: Other methods
extension WebService {
    
    func getFullUrl(relPath : String) throws -> URL {
        do {
            if relPath.lowercased().contains("http") || relPath.lowercased().contains("www") {
                return try relPath.asURL()
            } else {
                return try (_hostMode.baseUrl+relPath).asURL()
            }
        } catch let err {
            throw err
        }
    }
    
    func setAccesTokenToHeader(token:String) {
        self.token = AccessTokenAdapter(token: token)
    }
    
    func removeAccessTokenFromHeader() {
        self.token = nil
    }
}

// MARK: - Request, ImageUpload and Dowanload methods
extension WebService{
    
    @discardableResult
    func apiCall(relPath: String, method: HTTPMethod, param: [String: Any]?, headerParam: HTTPHeaders? = nil, encoding: ParameterEncoding = URLEncoding.default, block: @escaping WSBlock) -> DataRequest? {
        var combinedParameters: [String: Any]
        if let param = param {
            combinedParameters = param.merged(with: marvelAuthParameters)
        } else {
            combinedParameters = marvelAuthParameters
        }
        do {
            kprint(items: try getFullUrl(relPath: relPath))
            kprint(items: headerParam ?? headers)
            kprint(items: "Parameters: \(String(describing: combinedParameters))")
            return manager.request(try getFullUrl(relPath: relPath), method: method, parameters: combinedParameters, encoding: encoding, headers: headerParam ?? headers, interceptor: token).responseJSON { (res) in
                switch res.result {
                case .success(_):
                    if let resData = res.data {
                        do {
                            let respon = try JSONSerialization.jsonObject(with: resData, options: []) as AnyObject
                            self.successBlock(relPath, res.response, respon, block)
                        } catch let errParse {
                            kprint(items: errParse)
                            self.errorBlock(relPath, res.response, errParse as NSError, block)
                        }
                    }
                    break
                case .failure(let err):
                    kprint(items: err)
                    self.errorBlock(relPath, res.response, err as NSError, block)
                    break
                }
            }
        } catch let error {
            kprint(items: error)
            errorBlock(relPath, nil, error as NSError, block)
            return nil
        }
    }
    
//    func uploadFileToUrl(relPath: String, data: Data, block: @escaping WSBlock, progressB: WSProgress?) {
//
//        var request = URLRequest(url: URL(string: relPath)!,timeoutInterval: Double.infinity)
//        request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "PUT"
//        request.httpBody = data
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let res = response as? HTTPURLResponse {
//                DispatchQueue.main.async {
//                    block(nil, res.statusCode)
//                }
//            } else {
//                DispatchQueue.main.async {
//                    block(nil, 100)
//                }
//            }
//        }
//        task.resume()
//    }
}

// MARK: - Internet Availability
extension WebService {
    
    func addInterNetListner() {
        networkManager?.startListening(onUpdatePerforming: { [weak self] (status) in
            guard let weakSelf = self else{ return }
            if case .reachable(_) = status {
                kprint(items: "Internet Avail")
                if weakSelf.toast != nil{
                    weakSelf.toast.animateOut(duration: 0.2, delay: 0.2, completion: { () -> () in
                        weakSelf.toast.removeFromSuperview()
                        weakSelf.toast = nil
                    })
                }
            } else {
                kprint(items: "No InterNet")
                if weakSelf.toast == nil{
                    weakSelf.toast = KPValidationToast.shared.showStatusMessageForInterNet(message: kInternetDown)
                }
            }
        })
    }
    
    func isInternetAvailable() -> Bool {
        if let man = networkManager {
            if man.isReachable {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}

// MARK: - Home
extension WebService {
    
    func getCharacters(param: [String: Any], block: @escaping WSBlock) {
        kprint(items: "---------------- Get Charachters ----------------")
        let relPath = "characters"
        _ = apiCall(relPath: relPath, method: .get, param: param, block: block)
    }
    
    func getComicDetail(urlString: String, param: [String: Any], block: @escaping WSBlock) {
        kprint(items: "---------------- Get Comic Detail ----------------")
        let relPath = urlString
        _ = apiCall(relPath: relPath, method: .get, param: param, block: block)
    }
    
    func getCreatorDetail(urlString: String, param: [String: Any], block: @escaping WSBlock) {
        kprint(items: "---------------- Get Creator Detail ----------------")
        let relPath = urlString
        _ = apiCall(relPath: relPath, method: .get, param: param, block: block)
    }
}
