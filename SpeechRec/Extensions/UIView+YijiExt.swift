//
//  UIView+YijiExt.swift
//
// Copyright (c) 2016 

import UIKit


public extension UIView {
    // MARK: - UIView Rect    
    
    /// height
	var height: CGFloat {
		get { return frame.size.height }
		set { frame.size.height = newValue }
	}
    /// width
	var width: CGFloat {
		get { return frame.size.width }
		set { frame.size.width = newValue }
	}
    /// X
	var x: CGFloat {
		get { return frame.origin.x }
		set {
			var frame = self.frame
			frame.origin.x = newValue
			self.frame = frame
		}
	}
    /// Y
	var y: CGFloat {
		get { return frame.origin.y }
		set {
			var frame = self.frame
			frame.origin.y = newValue
			self.frame = frame
		}
	}
    /// minimum X
	var minX: CGFloat {
		return CGRectGetMinX(frame)
	}
    /// minimum Y
	var minY: CGFloat {
		return CGRectGetMinY(frame)
	}

	/// The horizontal center coordinate of the UIView.
	public var centerX: CGFloat {
		get {
			return frame.centerX
		}
		set(value) {
			var frame = self.frame
			frame.centerX = value
			self.frame = frame
		}
	}

	/// The vertical center coordinate of the UIView.
	public var centerY: CGFloat {
		get {
			return frame.centerY
		}
		set(value) {
			var frame = self.frame
			frame.centerY = value
			self.frame = frame
		}
	}
    /// maxmum X
	var maxX: CGFloat {
		return CGRectGetMaxX(frame)
	}
    /// maxmum Y
	var maxY: CGFloat {
		return CGRectGetMaxY(frame)
	}

}



extension CGRect: StringLiteralConvertible {
    // MARK: - UIView Extends CGRect with helper properties for positioning and setting dimensions
    
	/// The top coordinate of the rect.
	public var top: CGFloat {
		get {
			return origin.y
		}
		set(value) {
			origin.y = value
		}
	}

	/// The left-side coordinate of the rect.
	public var left: CGFloat {
		get {
			return origin.x
		}
		set(value) {
			origin.x = value
		}
	}

	/// The bottom coordinate of the rect. Setting this will change origin.y of the rect according to
	/// the height of the rect.
	public var bottom: CGFloat {
		get {
			return origin.y + size.height
		}
		set(value) {
			origin.y = value - size.height
		}
	}

	/// The right-side coordinate of the rect. Setting this will change origin.x of the rect according to
	/// the width of the rect.
	public var right: CGFloat {
		get {
			return origin.x + size.width
		}
		set(value) {
			origin.x = value - size.width
		}
	}

	/// The width of the rect.
	public var width: CGFloat {
		get {
			return size.width
		}
		set(value) {
			size.width = value
		}
	}

	/// The height of the rect.
	public var height: CGFloat {
		get {
			return size.height
		}
		set(value) {
			size.height = value
		}
	}

	/// The center x coordinate of the rect.
	public var centerX: CGFloat {
		get {
			return origin.x + size.width / 2
		}
		set (value) {
			origin.x = value - size.width / 2
		}
	}

	/// The center y coordinate of the rect.
	public var centerY: CGFloat {
		get {
			return origin.y + size.height / 2
		}
		set (value) {
			origin.y = value - size.height / 2
		}
	}

	/// The center of the rect.
	public var center: CGPoint {
		get {
			return CGPoint(x: centerX, y: centerY)
		}
		set (value) {
			centerX = value.x
			centerY = value.y
		}
	}

	public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType

    
	public init(stringLiteral value: StringLiteralType) {
		self.init()
		let rect: CGRect
		if value[value.startIndex] != "{" {
			let comp = value.componentsSeparatedByString(",")
			if comp.count == 4 {
				rect = CGRectFromString("{{\(comp[0]),\(comp[1])}, {\(comp[2]), \(comp[3])}}")
			} else {
				rect = CGRect.zero
			}
		} else {
			rect = CGRectFromString(value)
		}

		self.size = rect.size
		self.origin = rect.origin
	}

    /// init `self.init(stringLiteral: value)`
	public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
		self.init(stringLiteral: value)
	}

	public typealias UnicodeScalarLiteralType = StringLiteralType
    
    /// init `self.init(stringLiteral: value)`
	public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
		self.init(stringLiteral: value)
	}
}



extension CGPoint: StringLiteralConvertible {
    // MARK: - CGPint
    
    public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType

    /**
     init
     
     - parameter value:
     - returns: result
     */
	public init(stringLiteral value: StringLiteralType) {
		self.init()

		let point: CGPoint
		if value[value.startIndex] != "{" {
			point = CGPointFromString("{\(value)}")
		} else {
			point = CGPointFromString(value)
		}
		self.x = point.x
		self.y = point.y
	}
    
    /// init `self.init(stringLiteral: value)`
	public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
		self.init(stringLiteral: value)
	}
    
    /// init `self.init(stringLiteral: value)`
	public typealias UnicodeScalarLiteralType = StringLiteralType

	public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
		self.init(stringLiteral: value)
	}
}



@IBDesignable
public extension UIView {
    // MARK: - Useful param to UIView in xib
    
    
	@IBInspectable
	var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
		}
	}
    
	@IBInspectable
	var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}
	
	@IBInspectable
	var borderColor: UIColor? {
		get {
			guard let color = layer.borderColor else { return nil }
			return UIColor(CGColor: color)
		}
		set {
			layer.borderColor = newValue?.CGColor
		}
	}
}


public extension UIView {
    // MARK: - UIView Tap To Close Editing
    
   
	func addTapToCloseEditing() {
		let tapToHideKeyBoard = UITapGestureRecognizer(target: self, action: #selector(UIView.hideKeyboard))
		addGestureRecognizer(tapToHideKeyBoard)
	}
    
    /**
     hide keyboard
     */
	func hideKeyboard() {
		endEditing(true)
	}

}



public extension UIView {
    
	func screenshot() -> UIImage {
		UIGraphicsBeginImageContextWithOptions(frame.size, false, 2.0)
		layer.renderInContext(UIGraphicsGetCurrentContext()!)
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image
	}
}



public extension UIView {
    
	public func shakeWith(times: Int) {
		let anim = CAKeyframeAnimation(keyPath: "transform")
		anim.values = [
			NSValue(CATransform3D: CATransform3DMakeTranslation(-5, 0, 0)),
			NSValue(CATransform3D: CATransform3DMakeTranslation(5, 0, 0))
		]
		anim.autoreverses = true
		anim.repeatCount = Float(times)
		anim.duration = 7 / 100

		self.layer.addAnimation(anim, forKey: nil)
	}

}




public extension UIView {
    // MARK: - UIView Corner
    
	//  [UIRectCorner.TopLeft, UIRectCorner.TopRight]
	public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
		let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		let mask = CAShapeLayer()
		mask.path = path.CGPath
		layer.mask = mask
	}
    
    
	public func roundView() {
		layer.cornerRadius = min(frame.size.height, frame.size.width) / 2
	}

}

private let UIViewAnimationDuration: NSTimeInterval = 1
private let UIViewAnimationSpringDamping: CGFloat = 0.5
private let UIViewAnimationSpringVelocity: CGFloat = 0.5



public extension UIView {
    
    // MARK: - Animation Extensions
    
    
	public func spring(animations animations: (() -> Void), completion: ((Bool) -> Void)? = nil) {
		spring(duration: UIViewAnimationDuration, animations: animations, completion: completion)
	}
    
	public func spring(duration duration: NSTimeInterval, animations: (() -> Void), completion: ((Bool) -> Void)? = nil) {
		UIView.animateWithDuration(UIViewAnimationDuration, delay: 0, usingSpringWithDamping: UIViewAnimationSpringDamping, initialSpringVelocity: UIViewAnimationSpringVelocity, options: UIViewAnimationOptions.AllowAnimatedContent, animations: animations, completion: completion)
	}


    
	public func pop() {
		setScale(x: 1.1, y: 1.1)
		spring(duration: 0.2, animations: { [unowned self]() -> Void in
			self.setScale(x: 1, y: 1)
		})
	}
    
	public func popBig() {
		setScale(x: 1.25, y: 1.25)
		spring(duration: 0.2, animations: { [unowned self]() -> Void in
			self.setScale(x: 1, y: 1)
		})
	}
}



extension UIView{
    
	public func setScale(x x: CGFloat, y: CGFloat) {
		var transform = CATransform3DIdentity
		transform.m34 = 1.0 / -1000.0
		transform = CATransform3DScale(transform, x, y, 1)
		layer.transform = transform
	}

}
