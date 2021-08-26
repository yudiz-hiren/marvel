//  Created by iOS Development Company on 19/04/16.
//  Copyright © 2016 iOS Development Company All rights reserved.
//

import Foundation
import UIKit

//class KPTouch: ConstrainedView {
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//}

class KPShadowView: UIView {
    
    @IBInspectable var xPos: CGFloat = 0
    @IBInspectable var yPos: CGFloat = 2
    @IBInspectable var radious: CGFloat = 0
    @IBInspectable var opacity: CGFloat = 0.08
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = Float(opacity)
        layer.shadowOffset = CGSize(width: xPos, height: yPos)
        layer.shadowRadius = radious
        changeFrame()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        changeFrame()
    }
    
    func changeFrame() {
        let shadowRect = CGRect(origin: CGPoint.zero, size: CGSize(width: self.frame.width, height: self.frame.height))
        let path = UIBezierPath(rect: shadowRect)
        layer.shadowPath = path.cgPath
    }
}

class KPRoundButton: UIButton {
    
    @IBInspectable var isRatioAppliedOnSize: Bool = false
    
    @IBInspectable var isRationAppliedOnText: Bool = false{
        didSet{
            if isRationAppliedOnText, let afont = titleLabel?.font {
                titleLabel?.font = afont.withSize(afont.pointSize * _widthRatio)
            }
        }
    }
    
    @IBInspectable var cornerRadious: CGFloat = 0{
        didSet{
            if cornerRadious == 0{
                layer.cornerRadius = isRatioAppliedOnSize ? (self.frame.height * _widthRatio) / 2 : self.frame.height / 2
            }else{
                layer.cornerRadius = isRatioAppliedOnSize ? cornerRadious * _widthRatio : cornerRadious
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
    }
}

class KPRoundLabel: UILabel {
    
    @IBInspectable var isRatioAppliedOnSize: Bool = false
    
    @IBInspectable var isRationAppliedOnText: Bool = false{
        didSet{
            if isRationAppliedOnText {
                font = font.withSize(font.pointSize * _widthRatio)
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadious: CGFloat = 0{
        didSet{
            if cornerRadious == 0 {
                layer.cornerRadius = isRatioAppliedOnSize ? (self.frame.height * _widthRatio) / 2 : self.frame.height / 2
            }else{
                layer.cornerRadius = isRatioAppliedOnSize ? cornerRadious * _widthRatio : cornerRadious
            }
        }
    }
    
    @IBInspectable var letterSpace : CGFloat = 0{
        didSet{
            letterSpace = letterSpace * _widthRatio
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
    }
}

class KPRoundTextField: UITextField {
    
    @IBInspectable var isRatioAppliedOnSize: Bool = false
    
    @IBInspectable var isRationAppliedOnText: Bool = false{
        didSet{
            if isRationAppliedOnText {
                font = font?.withSize((font?.pointSize)! * _widthRatio)
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadious: CGFloat = 0{
        didSet{
            if cornerRadious == 0{
                layer.cornerRadius = isRatioAppliedOnSize ? (self.frame.height * _widthRatio) / 2 : self.frame.height / 2
            }else{
                layer.cornerRadius = isRatioAppliedOnSize ? cornerRadious * _widthRatio : cornerRadious
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
    }
}

class KPRoundView: UIView {
    
    @IBInspectable var isRatioAppliedOnSize: Bool = false
    
    @IBInspectable var cornerRadious: CGFloat = 0{
        didSet{
            if cornerRadious == 0{
                layer.cornerRadius = isRatioAppliedOnSize ? (self.frame.height * _widthRatio) / 2 : self.frame.height / 2
            }else{
                layer.cornerRadius = isRatioAppliedOnSize ? cornerRadious * _widthRatio : cornerRadious
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if cornerRadious == 0{
            layer.cornerRadius = isRatioAppliedOnSize ? (self.frame.height * _widthRatio) / 2 : self.frame.height / 2
        }else{
            layer.cornerRadius = isRatioAppliedOnSize ? cornerRadious * _widthRatio : cornerRadious
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
    }
}

class RoundView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var topLeft: Bool = true
    @IBInspectable var topRight: Bool = true
    @IBInspectable var bottomLeft: Bool = true
    @IBInspectable var bottomRight: Bool = true

    override func awakeFromNib() {
        super.awakeFromNib()
        guard cornerRadius >= 0 else { return }
        clipsToBounds = true
        layer.masksToBounds = true
        layer.maskedCorners = getMaskCorners()
    }

    override func layoutSubviews() {
        let updateRadius = cornerRadius == 0 ? frame.height / 2 : cornerRadius
        layer.cornerRadius = updateRadius
    }

    func getMaskCorners()-> CACornerMask {
        var mask = CACornerMask()
        if topLeft {
            mask.insert(.layerMinXMinYCorner)
        }
        if topRight {
            mask.insert(.layerMaxXMinYCorner)
        }
        if bottomLeft {
            mask.insert(.layerMinXMaxYCorner)
        }
        if bottomRight {
            mask.insert(.layerMaxXMaxYCorner)
        }
        return mask
    }
}

// MARK: - Horizontal DashView
class HorizontalDashView: UIView {

    @IBInspectable var lineWidth: CGFloat = 1
    @IBInspectable var dashHeight: Float = 3

    override func layoutSubviews() {
        super.layoutSubviews()
        addDashLayer()
    }

    func addDashLayer() {
        let dashLayer = CAShapeLayer()
        dashLayer.frame = bounds
        dashLayer.path = getHorizontalLinePath()
        dashLayer.lineWidth = lineWidth
        dashLayer.lineDashPattern = [dashHeight as NSNumber]
        dashLayer.lineDashPhase = 0
        dashLayer.strokeColor = backgroundColor?.cgColor
        layer.mask = dashLayer
    }

    func getHorizontalLinePath()-> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: bounds.height / 2))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height / 2))
        return path.cgPath
    }
}

// MARK: - Vertical DashView
class VerticalDashView: UIView {

    @IBInspectable var lineWidth: CGFloat = 1
    @IBInspectable var dashHeight: Float = 5

    override func layoutSubviews() {
        super.layoutSubviews()
        addDashLayer()
    }

    func addDashLayer() {
        let dashLayer = CAShapeLayer()
        dashLayer.frame = bounds
        dashLayer.path = getVerticalDashPath()
        dashLayer.lineWidth = lineWidth
        dashLayer.lineDashPattern = [dashHeight as NSNumber]
        dashLayer.lineDashPhase = 0
        dashLayer.strokeColor = backgroundColor?.cgColor
        layer.mask = dashLayer
    }

    func getVerticalDashPath()-> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.width / 2, y: 0))
        path.addLine(to: CGPoint(x: bounds.width / 2, y: bounds.height))
        return path.cgPath
    }
}

class KPRoundViewNew: UIView {
    @IBInspectable var cornerSize: CGFloat = 0
    @IBInspectable var isTopCorner: Bool = false
    @IBInspectable var isAllCorner: Bool = false
    @IBInspectable var bgColor: UIColor = UIColor.white

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        let mask = CAShapeLayer()
        mask.lineWidth = 0
        mask.strokeColor = UIColor.clear.cgColor
        mask.fillColor = bgColor.cgColor
        self.layer.addSublayer(mask)
        for view in self.subviews{
            self.bringSubviewToFront(view)
        }
        clipsToBounds = true
        layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let cornerS = cornerSize == 0 ? self.frame.height / 2 : cornerSize
        let cornerDirection: UIRectCorner = isAllCorner ? [.allCorners] : isTopCorner ? [UIRectCorner.topLeft, UIRectCorner.topRight] : [UIRectCorner.bottomLeft, UIRectCorner.bottomRight]
        if let layers = self.layer.sublayers {
            for layr in layers {
                if let newLay =  layr as? CAShapeLayer {
                    let rect = CGRect(origin: self.bounds.origin, size: CGSize(width: self.frame.width, height: self.frame.height))
                    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: cornerDirection, cornerRadii: CGSize(width: cornerS, height: cornerS))
                    newLay.path = path.cgPath
                    break
                }
            }
        }
    }
}

class KPRoundImageView: UIImageView {
    
    @IBInspectable var isRatioAppliedOnSize: Bool = false
    
    @IBInspectable var cornerRadious: CGFloat = 0{
        didSet{
            if cornerRadious == 0{
                layer.cornerRadius = isRatioAppliedOnSize ? (self.frame.height * _widthRatio) / 2 : self.frame.height / 2
            }else{
                layer.cornerRadius = isRatioAppliedOnSize ? cornerRadious * _widthRatio : cornerRadious
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
    }
}

