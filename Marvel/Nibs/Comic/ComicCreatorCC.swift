//
//  ComicCreatorCC.swift
//  Marvel
//
//  Created by Yudiz Solutions Pvt. Ltd. on 26/08/21.
//

import UIKit

class ComicCreatorCC: ParentCC {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRole: UILabel!
    
    weak var parentVC: ComicDetailVC!
    weak var creator: ComicCreator!
    
    
    func prepareUI() {
        lblName.text = creator.name
        lblRole.text = creator.role
        setImage()
        if creator.detail == nil {
            getDetail(uri: creator.resourceURI)
        }
    }
    
    func setImage() {
        if let detail = creator.detail {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
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
        WebService.shared.getCreatorDetail(urlString: uri, param: [:]) {[weak self] (json, statusCode) in
            guard let weakSelf = self else { return }
            if statusCode == 200, let dict = json as? NSDictionary {
                if let dataDict = dict["data"] as? NSDictionary {
                    if let resultDict = dataDict["results"] as? [NSDictionary], let dict = resultDict.first {
                        weakSelf.creator.detail = ComicCreatorDetail(dict: dict)
                    }
                }
            } else {
                weakSelf.parentVC.showError(data: json)
            }
            weakSelf.setImage()
        }
    }
}
