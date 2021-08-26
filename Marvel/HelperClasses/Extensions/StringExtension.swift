//  Created by Tom Swindell on 07/12/2015.
//  Copyright © 2015 The App Developers. All rights reserved.
//

import Foundation
import UIKit
import CoreTelephony
import CryptoKit

// MARK: - Character check
extension String {

    func trimmedString() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }

    func contains(find: String) -> Bool{
        return self.range(of: find, options: String.CompareOptions.caseInsensitive) != nil
    }
}
// MARK: - Layout
extension String {

    var length: Int {
        return (self as NSString).length
    }

    func isEqual(str: String, isCaseSensitive: Bool = true) -> Bool {
        if isCaseSensitive {
            return self.compare(str) == ComparisonResult.orderedSame
        } else {
            return self.caseInsensitiveCompare(str) == .orderedSame
        }
    }

    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [NSStringDrawingOptions.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }

    func WidthWithNoConstrainedHeight(font: UIFont) -> CGFloat {
        let width = CGFloat.greatestFiniteMagnitude
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.width
    }
}
