//
//  TitleTC.swift
//  Marvel
//
//  Created by Yudiz Solutions Pvt. Ltd. on 26/08/21.
//

import UIKit

class TitleTC: ParentTC {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    func prepareUI(title: String) {
        lblTitle.text = title
    }
}
