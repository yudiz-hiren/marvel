//
//  ComicCC.swift
//  Marvel
//
//  Created by Yudiz Solutions Pvt. Ltd. on 26/08/21.
//

import UIKit
import Kingfisher

class ComicCC: ParentCC {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    weak var parentVC: CharacterDetailVC!
    weak var comic: Comic!
    
    func prepareUI() {
        lblName.text = comic.name
        setImage()
        if comic.detail == nil {
            getDetail(uri: comic.resourceURI)
        }
//        if let detail = comic.detail {
//            activityIndicator.isHidden = true
//            activityIndicator.stopAnimating()
//            imgView.kf.setImage(with: detail.thumbnail?.standartFantasticURL, placeholder: _userPlaceholder)
//        } else {
//            activityIndicator.isHidden = false
//            activityIndicator.startAnimating()
//            WebService.shared.getComicDetail(urlString: comic.resourceURI, param: [:]) {[weak self] (json, statusCode) in
//                guard let weakSelf = self else { return }
//                if statusCode == 200, let dict = json as? NSDictionary {
//                    if let dataDict = dict["data"] as? NSDictionary {
//                        if let resultDict = dataDict["results"] as? [NSDictionary], let dict = resultDict.first {
//                            comic.detail = ComicDetail(dict: dict)
//                            weakSelf.activityIndicator.stopAnimating()
//                            weakSelf.activityIndicator.isHidden = true
//                            weakSelf.imgView.kf.setImage(with: comic.detail?.thumbnail?.standartFantasticURL, placeholder: _userPlaceholder)
//                        }
//                    }
//                } else {
//                    weakSelf.parentVC.showError(data: json)
//                    weakSelf.activityIndicator.stopAnimating()
//                    weakSelf.activityIndicator.isHidden = true
//                    weakSelf.imgView.image = _userPlaceholder
//                    weakSelf.imgView.contentMode = .scaleAspectFit
//                }
//            }
//        }
    }
    
    func setImage() {
        if let detail = comic.detail {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            imgView.kf.setImage(with: detail.thumbnail?.standartFantasticURL, placeholder: _placeholder)
            imgView.kf.setImage(with: detail.thumbnail?.standartFantasticURL, placeholder: _placeholder, options: nil) {[weak self] (result) in
                guard let weakSelf = self else { return }
                switch result {
                case .success(let _):
                    weakSelf.imgView.contentMode = .scaleAspectFill
                case .failure(let _):
                    weakSelf.imgView.contentMode = .scaleAspectFit
                }
            }
        } else {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
    }
    
    func getDetail(uri: String) {
        WebService.shared.getComicDetail(urlString: uri, param: [:]) {[weak self] (json, statusCode) in
            guard let weakSelf = self else { return }
            if statusCode == 200, let dict = json as? NSDictionary {
                if let dataDict = dict["data"] as? NSDictionary {
                    if let resultDict = dataDict["results"] as? [NSDictionary], let dict = resultDict.first {
                        weakSelf.comic.detail = ComicDetail(dict: dict)
                    }
                }
            } else {
                weakSelf.parentVC.showError(data: json)
            }
            weakSelf.setImage()
        }
    }
}
