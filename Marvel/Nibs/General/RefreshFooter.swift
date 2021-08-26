//
//  RefreshFooter.swift
//  Marvel
//
//  Created by Yudiz Solutions Pvt. Ltd. on 26/08/21.
//

import UIKit

class RefreshFooter: ParentHeaderFooter {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.white
    }
    
    func prepareUI() {
        activityIndicator.startAnimating()
    }
}
