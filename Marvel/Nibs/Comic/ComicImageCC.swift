//
//  ComicImageCC.swift
//  Marvel
//
//  Created by Yudiz Solutions Pvt. Ltd. on 26/08/21.
//

import UIKit
import Kingfisher

class ComicImageCC: ParentCC {
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    func prepareUI(url: URL?) {
        imgView.kf.setImage(with: url, placeholder: _placeholder, options: nil) {[weak self] (result) in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let _):
                weakSelf.imgView.contentMode = .scaleAspectFill
            case .failure(let _):
                weakSelf.imgView.contentMode = .scaleAspectFit
            }
        }
    }
}
