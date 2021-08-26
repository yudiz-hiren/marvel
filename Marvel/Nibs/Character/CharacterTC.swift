//
//  CharacterTC.swift
//  Marvel
//
//  Created by Yudiz Solutions Pvt. Ltd. on 25/08/21.
//

import UIKit
import Kingfisher

class CharacterTC: ParentTC {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    func prepareUI(character: MarvelCharacter) {
        lblName.text = character.name
        imgView.kf.setImage(with: character.thumbnail?.standardSmallURL, placeholder: _userPlaceholder)
    }
}

