//
//  NoComicCC.swift
//  Marvel
//
//  Created by Yudiz Solutions Pvt. Ltd. on 26/08/21.
//

import UIKit

class NoDataCC: ParentCC {
    
    @IBOutlet weak var lblMessage: UILabel!
    
    func prepareUI(message: String) {
        lblMessage.text = message
    }
    
}
