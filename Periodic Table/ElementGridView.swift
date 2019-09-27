//
//  ElementGridView.swift
//  Periodic Table
//
//  Created by Nhan Cao on 9/18/19.
//  Copyright © 2019 Nhan Cao. All rights reserved.
//

import UIKit

@IBDesignable
class ElementGridView: UIView {
    
    var symbol: String? = "K"
    var number: Int? = 19
    
    var textColor = UIColor.white
    
    
    override var bounds: CGRect {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    func display(symbol: String?, number: Int?) {
        self.symbol = symbol
        self.number = number
    
        self.setNeedsDisplay()
    }
    
    var isSelected = false {
        didSet {
            if isSelected {
                textColor = UIColor.black
                self.backgroundColor = UIColor.white
            } else {
                textColor = UIColor.white
                self.backgroundColor = UIColor.black
            }
            self.setNeedsDisplay()
        }
    }
//    static var x = 0
    override func draw(_ rect: CGRect) {
//        ElementGridView.x+=1
//        print("draw \(ElementGridView.x)")
        
        if isSelected {
            textColor = UIColor.black
            self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            textColor = UIColor.white
            self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        self.setNeedsDisplay()
        
        
        let subviews = self.subviews
        for view in subviews {
            view.removeFromSuperview()
        }
        
        let edge = min(self.frame.height, self.frame.width)
        let gridFrame = CGRect(x: (self.frame.width-edge)/2, y: (self.frame.height-edge)/2, width: edge, height: edge)
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        
////////////////////////////////
//        COLOR
//        let bgColor = getBackgroundColor(of: number)
//        
//        let displayBox = UIBezierPath(rect: gridFrame)
//        displayBox.addClip()
//        bgColor.setFill()
//        displayBox.fill()
//
//        UIColor.white.setStroke()
//        displayBox.lineWidth = edge*SizeRatio.strokeToEdge
//        displayBox.stroke()
//
////////////////////////////////
        
        let symbolLabel = UILabel(frame: gridFrame.zoomCenter(to: SizeRatio.symbolMasterBoxToEdge).zoomHeightToCenter(to: SizeRatio.symbolLabelToEdge))
        symbolLabel.font = UIFont(name: "HelveticaNeue-Bold", size: symbolLabel.frame.height*SizeRatio.fontToHeight)
        symbolLabel.textAlignment = .center
        symbolLabel.text = symbol
        symbolLabel.textColor = textColor
        symbolLabel.adjustsFontSizeToFitWidth = true
        
        self.addSubview(symbolLabel)
        
        let numberLabel = UILabel(frame: CGRect(x: gridFrame.minX + edge*SizeRatio.numberLabelOffSetToEdge, y: gridFrame.minY + edge*SizeRatio.numberLabelOffSetToEdge, width: gridFrame.width, height: edge*SizeRatio.numberLabelHeightToEdge) )
        if number != nil {
            numberLabel.text = String(number!)
        } else {
            numberLabel.text = ""
        }
        numberLabel.textColor = textColor
        numberLabel.font = UIFont(name: "HelveticaNeue", size: numberLabel.frame.height)
        
        self.addSubview(numberLabel)
    }
    
    private func getBackgroundColor(of code: Int?) -> UIColor {
        if code == nil {
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        switch code! {
        case 1, 6...8, 15, 16, 34:
            // Nonmetal
            return #colorLiteral(red: 0.6410360932, green: 0.69108814, blue: 0.852938354, alpha: 1)
        case 2, 10, 18, 36, 54, 86:
            // Noble Gas
            return #colorLiteral(red: 0.8033756018, green: 0.6272006035, blue: 0.7920130491, alpha: 1)
        case 3, 11, 19, 37, 55, 87:
            // Alkali Metal
            return #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        case 4, 12, 20, 38, 56, 88:
            // Alkaline Earth
            return #colorLiteral(red: 0.9965631366, green: 0.8223482966, blue: 0.5765100121, alpha: 1)
        case 5, 14, 32, 33, 51, 52, 84:
            // Metalloid
            return #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        case 9, 17, 35, 53, 85, 117:
            // Halogen
            return #colorLiteral(red: 0.6914058924, green: 0.6114787459, blue: 0.7975903153, alpha: 1)
        case 13, 31, 49, 50, 81...83, 113...116:
            // Basic Metal
            return #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        case 21...30, 39...48, 72...80, 104...112:
            // Transition Metal
            return #colorLiteral(red: 0.9657002091, green: 0.9577662349, blue: 0.6001313329, alpha: 1)
        case 57...71:
            // Lanthanide
            return #colorLiteral(red: 0.9353649616, green: 0.6227476597, blue: 0.774107039, alpha: 1)
        case 89...103:
            // Actinide
            return #colorLiteral(red: 0.89069134, green: 0.666757226, blue: 0.8062852025, alpha: 1)
        default:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
 

}

extension ElementGridView {
    struct SizeRatio {
        static let strokeToEdge: CGFloat = 0.1
        static let symbolMasterBoxToEdge: CGFloat = 0.9
        static let symbolLabelToEdge: CGFloat = 0.7
        static let fontToHeight: CGFloat = 0.7
        static let numberLabelOffSetToEdge: CGFloat = 0.1
        static let numberLabelHeightToEdge: CGFloat = 0.18
        
    }
}

extension CGRect {
    func zoomCenter(to ratio: CGFloat) -> CGRect {
        let newWidth = self.width*ratio
        let newHeight = self.height*ratio
        return CGRect(x: self.midX-newWidth/2, y: self.midY-newHeight/2, width: newWidth, height: newHeight)
    }
    
    func zoomHeightToCenter(to ratio: CGFloat) -> CGRect {
        let newHeight = self.height*ratio
        return CGRect(x: self.minX, y: self.midY-newHeight/2, width: self.width, height: newHeight)
    }
}
