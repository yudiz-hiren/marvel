//
//  NoDataTC.swift
//  Marvel
//
//  Created by Yudiz Solutions Pvt. Ltd. on 25/08/21.
//

import UIKit

class NoDataTC: ParentTC {
    
    @IBOutlet weak var lblMessage: UILabel!
    
    func prepareUI(message: String) {
        lblMessage.text = message
    }
}
