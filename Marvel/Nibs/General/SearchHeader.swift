//
//  SearchHeader.swift
//  Marvel
//
//  Created by Yudiz Solutions Pvt. Ltd. on 26/08/21.
//

import UIKit

protocol SearchHeaderDelegate {
    func didChange(text: String)
}

class SearchHeader: ParentHeaderFooter {
    
    @IBOutlet weak var tf: UITextField!
    var delegate: SearchHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.white
    }
    
    func prepareUI(placeholder: String) {
        tf.placeholder = placeholder
    }
}

// MARK: - TextField method(s)
extension SearchHeader: UITextFieldDelegate {
    
    @IBAction func tfChange() {
        delegate?.didChange(text: tf.text!.trimmedString())
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
