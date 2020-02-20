import UIKit

extension UILabel {
    
    func underline(color: UIColor) {
        
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let borderWidth = CGFloat(1.0)
        let endBorderHeight = CGFloat(10.0)
        
        let bottom = CALayer()
        bottom.frame = CGRect(
            x: 1,
            y: self.frame.height - borderWidth,
            width: self.frame.width - 2,
            height: borderWidth)
        
        bottom.borderWidth = borderWidth
        bottom.borderColor = color.cgColor
        
        let leftEndBorder = CALayer()
        leftEndBorder.frame = CGRect(
            x: 0,
            y: self.frame.height - endBorderHeight,
            width: borderWidth,
            height: endBorderHeight)
        leftEndBorder.borderWidth = borderWidth
        leftEndBorder.borderColor = color.cgColor
        
        let rightEndBorder = CALayer()
        rightEndBorder.frame = CGRect(
            x: self.frame.width - 1,
            y: self.frame.height - endBorderHeight,
            width: borderWidth,
            height: endBorderHeight)
        
        rightEndBorder.borderWidth = borderWidth
        rightEndBorder.borderColor = color.cgColor
        
        self.layer.addSublayer(leftEndBorder)
        self.layer.addSublayer(bottom)
        self.layer.addSublayer(rightEndBorder)
        self.layer.masksToBounds = true
    }
    
}
