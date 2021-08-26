//
//  CharacterDescriptionTC.swift
//  Marvel
//
//  Created by Yudiz Solutions Pvt. Ltd. on 26/08/21.
//

import UIKit

class DescriptionTC: ParentTC {
    
    @IBOutlet weak var lblDescription: UILabel!
    
    func prepareUI(description: String) {
        lblDescription.text = description
    }
}
