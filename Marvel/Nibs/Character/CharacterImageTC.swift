//
//  CharacterImageTC.swift
//  Marvel
//
//  Created by Yudiz Solutions Pvt. Ltd. on 26/08/21.
//

import UIKit
import Kingfisher

class CharacterImageTC: ParentTC {
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var characterImageView: UIImageView!
    
    func prepareUI(thumbnail: Image?) {
        guard let thumbnail = thumbnail else {
            characterImageView.image = _userPlaceholder
            return
        }
        backImageView.kf.setImage(with: thumbnail.landscapeIncredibleURL)
        characterImageView.kf.setImage(with: thumbnail.standartFantasticURL, placeholder: _userPlaceholder)
    }
}
