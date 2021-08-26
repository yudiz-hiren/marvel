//  Created by iOS Development Company on 13/01/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit

enum FontType: String {
    case book = "Avenir-Book"
    case medium = "Avenir-Medium"
    case heavy = "Avenir-Heavy"
}

struct AppFont {
    static func fontWithName(_ name: FontType, size: CGFloat) -> UIFont {
        return UIFont(name: name.rawValue, size: size)!
    }
}

extension UIFont {
    
    static func printAllFonts() {
        for family in UIFont.familyNames {
            kprint(items: "----- \(family) -----")
            for name in UIFont.fontNames(forFamilyName: family) {
                kprint(items: "\(name)")
            }
        }
    }
}
