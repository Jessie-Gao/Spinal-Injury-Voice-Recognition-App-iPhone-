//
//  UIColor+yjExt.swift
//
// Copyright (c) 2016 

import UIKit


public extension UIColor {
    
    ///  (inverse color)
    var mt_inverseColor:UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red:1 - red, green: 1 - green, blue: 1 - blue, alpha: alpha)
    }
    
    var mt_binaryColor:UIColor {
        
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        
        return white > 0.92 ? UIColor.blueColor() : UIColor.whiteColor()
    }
    
    
    /// init method with RGB values from 0 to 255, instead of 0 to 1
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    /// init
    public convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
        let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
        let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     init
     
     - parameter hexString:  #223442 0x435353
     - parameter alpha:     transparent
     
     - returns: color
     */
    public convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString.stringByReplacingOccurrencesOfString("0x", withString: "")
        formatted = formatted.stringByReplacingOccurrencesOfString("#", withString: "")
        if let hex = Int(formatted, radix: 16) {
            self.init(hex: hex, alpha: alpha)
        } else {
            return nil
        }
    }
    
    /// init method from Gray value
    public convenience init(gray: CGFloat, alpha: CGFloat = 1) {
        self.init(red: gray/255, green: gray/255, blue: gray/255, alpha: alpha)
    }
    
    /// red
    public var redComponent: Int {
        var r: CGFloat = 0
        getRed(&r, green: nil, blue: nil, alpha: nil)
        return Int(r * 255)
    }
    
    /// green
    public var greenComponent: Int {
        var g: CGFloat = 0
        getRed(nil, green: &g, blue: nil, alpha: nil)
        return Int(g * 255)
    }
    
    /// blue
    public var blueComponent: Int {
        var b: CGFloat = 0
        getRed(nil, green: nil, blue: &b, alpha: nil)
        return Int(b * 255)
    }
    
    /// transparent
    public var alpha: Int {
        var a: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &a)
        return Int(a)
    }
    
    /**
     random a color
     
     - parameter randomAlpha: random transparent
     
     - returns: color
     */
    public static func randomColor(randomAlpha: Bool = false) -> UIColor {
        let randomRed = CGFloat.random()
        let randomGreen = CGFloat.random()
        let randomBlue = CGFloat.random()
        let alpha = randomAlpha ? CGFloat.random() : 1.0
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha)
    }
    
}

public extension UIColor {
    /// isDark
    public var isDark: Bool {
        let RGB = CGColorGetComponents(CGColor)
        return (0.2126 * RGB[0] + 0.7152 * RGB[1] + 0.0722 * RGB[2]) < 0.5
    }
    
    /// isBlackOrWhite
    public var isBlackOrWhite: Bool {
        let RGB = CGColorGetComponents(CGColor)
        return (RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91) || (RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09)
    }
    
    /// isBlack
    public var isBlack: Bool {
        let RGB = CGColorGetComponents(CGColor)
        return (RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09)
    }
    /// isWhite
    public var isWhite: Bool {
        let RGB = CGColorGetComponents(CGColor)
        return (RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91)
    }
    
    public func isDistinctFrom(color: UIColor) -> Bool {
        let bg = CGColorGetComponents(CGColor)
        let fg = CGColorGetComponents(color.CGColor)
        let threshold: CGFloat = 0.25
        var result = false
        
        if fabs(bg[0] - fg[0]) > threshold || fabs(bg[1] - fg[1]) > threshold || fabs(bg[2] - fg[2]) > threshold {
            if fabs(bg[0] - bg[1]) < 0.03 && fabs(bg[0] - bg[2]) < 0.03 {
                if fabs(fg[0] - fg[1]) < 0.03 && fabs(fg[0] - fg[2]) < 0.03 {
                    result = false
                }
            }
            result = true
        }
        
        return result
    }
    
    
    public func isContrastingWith(color: UIColor) -> Bool {
        let bg = CGColorGetComponents(CGColor)
        let fg = CGColorGetComponents(color.CGColor)
        
        let bgLum = 0.2126 * bg[0] + 0.7152 * bg[1] + 0.0722 * bg[2]
        let fgLum = 0.2126 * fg[0] + 0.7152 * fg[1] + 0.0722 * fg[2]
        let contrast = bgLum > fgLum
            ? (bgLum + 0.05) / (fgLum + 0.05)
            : (fgLum + 0.05) / (bgLum + 0.05)
        
        return 1.6 < contrast
    }
    
    
    public func colorWithMinimumSaturation(minSaturation: CGFloat) -> UIColor {
        var (hue, saturation, brightness, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return saturation < minSaturation
            ? UIColor(hue: hue, saturation: minSaturation, brightness: brightness, alpha: alpha)
            : self
    }

}

private extension CGFloat {
    /**
     generate random number
     
     - parameter lower: start number
     - parameter upper: end number
     
     - returns: random
     */
    static func random(lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
}

