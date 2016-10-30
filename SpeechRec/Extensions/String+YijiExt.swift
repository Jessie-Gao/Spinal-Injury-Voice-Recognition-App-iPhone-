//
//  String+yjExt.swift
//
// Copyright (c) 2016 

import Foundation
import UIKit

public extension String {

	/// Checking if String contains input
	public func contains(find: String) -> Bool {
		return self.rangeOfString(find) != nil
	}

	/// Checking if String contains input with comparing options
	public func contains(find: String, compareOption: NSStringCompareOptions) -> Bool {
		return self.rangeOfString(find, options: compareOption) != nil
	}
}

public extension String {
    /**
     combine string
     */
	func stringByAppendingPathComponent(path: String) -> String {
		return (self as NSString).stringByAppendingPathComponent(path)
	}
}

public extension String {
    
	func toDate() -> NSDate? {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

		if let date = dateFormatter.dateFromString(self) {
			return date
		} else {
			return nil
		}
	}
}

public extension String {
   
    enum TrimmingType {
        /// space
		case Whitespace
        /// space and newline
		case WhitespaceAndNewline
	}
    
    
	func trimming(trimmingType: TrimmingType) -> String {
		switch trimmingType {
		case .Whitespace:
			return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
		case .WhitespaceAndNewline:
			return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
		}
	}
    
    /// remove \n
	var mt_removeAllNewLines: String {
		return self.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()).joinWithSeparator("")
	}

    
	func mt_truncate(length: Int, trailing: String? = nil) -> String {
		if self.characters.count > length {
			return self.substringToIndex(self.startIndex.advancedBy(length)) + (trailing ?? "")
		} else {
			return self
		}
	}

}

public extension String {
    // MARK: - Range
    
    
	func mt_rangeFromNSRange(nsRange: NSRange) -> Range<Index>? {

		let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
		let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)

		guard let from = String.Index(from16, within: self),
			let to = String.Index(to16, within: self) else {
				return nil
		}

		return from ..< to
	}
    
    
	func mt_NSRangeFromRange(range: Range<Index>) -> NSRange {

		let utf16view = self.utf16
		let from = String.UTF16View.Index(range.startIndex, within: utf16view)
		let to = String.UTF16View.Index(range.endIndex, within: utf16view)

		return NSMakeRange(utf16view.startIndex.distanceTo(from), from.distanceTo(to))
	}
}

public extension String {

	func mt_mentionWordInIndex(index: Int) -> (wordString: String, mentionWordRange: Range<Index>)? {

		// println("startIndex: \(startIndex), endIndex: \(endIndex), index: \(index), length: \((self as NSString).length), count: \(self.characters.count)")

		guard index > 0 else {
			return nil
		}

		let nsRange = NSMakeRange(index, 0)
		guard let range = self.mt_rangeFromNSRange(nsRange) else {
			return nil
		}
		let index = range.startIndex

		var wordString: String?
		var wordRange: Range<Index>?

		self.enumerateSubstringsInRange(startIndex ..< endIndex, options: [.ByWords, .Reverse]) { (substring, substringRange, enclosingRange, stop) -> () in

			// println("substring: \(substring)")
			// println("substringRange: \(substringRange)")
			// println("enclosingRange: \(enclosingRange)")

			if substringRange.contains(index) {
				wordString = substring
				wordRange = substringRange
				stop = true
			}
		}

		guard let _wordString = wordString, _wordRange = wordRange else {
			return nil
		}

		guard _wordRange.startIndex != startIndex else {
			return nil
		}

		let mentionWordRange = _wordRange.startIndex.advancedBy(-1) ..< _wordRange.endIndex

		let mentionWord = substringWithRange(mentionWordRange)

		guard mentionWord.hasPrefix("@") else {
			return nil
		}

		return (_wordString, mentionWordRange)
	}
}

extension String {

    
	var mt_embeddedURLs: [NSURL] {

		guard let detector = try? NSDataDetector(types: NSTextCheckingType.Link.rawValue) else {
			return []
		}

		var URLs = [NSURL]()

		detector.enumerateMatchesInString(self, options: [], range: NSMakeRange(0, (self as NSString).length)) { result, flags, stop in

			if let URL = result?.URL {
				URLs.append(URL)
			}
		}

		return URLs
	}

    
	var mt_firstImageURL: NSURL? {

		let URLs = mt_embeddedURLs

		guard !URLs.isEmpty else {
			return nil
		}

		let imageExtentions = [
			"png",
			"jpg",
			"jpeg",
		]

		for URL in URLs {
			if let pathExtension = URL.pathExtension?.lowercaseString {
				if imageExtentions.contains(pathExtension) {
					return URL
				}
			}
		}

		return nil
	}
    
    
	var change2English: String {
		let mutableString = NSMutableString(string: self) as CFMutableString
		
		CFStringTransform(mutableString, UnsafeMutablePointer<CFRange>(nil), kCFStringTransformMandarinLatin, false)
		
		CFStringTransform(mutableString, UnsafeMutablePointer<CFRange>(nil), kCFStringTransformStripDiacritics, false)

		return mutableString as String
	}

    
	var firstCharactor: String? {
		
		let mutableString: NSMutableString = NSMutableString(string: self)
		
		CFStringTransform(mutableString, UnsafeMutablePointer<CFRange>(nil), kCFStringTransformMandarinLatin, false)
		
		CFStringTransform(mutableString, UnsafeMutablePointer<CFRange>(nil), kCFStringTransformStripDiacritics, false)
		
		let pinYin: String = mutableString.capitalizedString
		// return pinYin.substringToIndex(pinYin.startIndex.advancedBy(1)) //pinYin.startIndex.successor())
		return pinYin[0 ..< 1]
	}
}


public extension String {
    // MARK: - Cut Check
    
	///  (Cut string from integerIndex to the end)
	public subscript(integerIndex: Int) -> Character {
		let index = startIndex.advancedBy(integerIndex)
		return self[index]
	}

	///  (Cut string from range)
	public subscript(integerRange: Range<Int>) -> String {
		let start = startIndex.advancedBy(integerRange.startIndex)
		let end = startIndex.advancedBy(integerRange.endIndex)
		let range = start ..< end
		return self[range]
	}

	///  （Character count）
	public var length: Int {
		return self.characters.count
	}

	/// (Counts number of instances of the input inside String)
	func count(substring: String) -> Int {
		return componentsSeparatedByString(substring).count - 1
	}
	func replace(target: String, withString: String) -> String {
		return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
	}
	/// (Capitalizes first character of String)
	public var capitalizeFirst: String {
		var result = self
		result.replaceRange(startIndex ... startIndex, with: String(self[startIndex]).capitalizedString)
		return result
	}
    
    /// empty
	func isEmpty() -> Bool {
		return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).length == 0
	}
    
    ///  (Counts whitespace & new lines)
	func lines() -> [String] {
		return self.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
	}

	/// space
	public func isOnlyEmptySpacesAndNewLineCharacters() -> Bool {
		let characterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
		let newText = self.stringByTrimmingCharactersInSet(characterSet)
		return newText.isEmpty
	}

	/// (Trims white space and new line characters)
	public mutating func trim() {
		self = self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
	}
    
    /**
     
     - parameter startIndex: start index
     - parameter length:     length
     
     - returns: string
     */
	func subString(startIndex: Int, length: Int) -> String {
		let start = self.startIndex.advancedBy(startIndex)
		let end = self.startIndex.advancedBy(startIndex + length)
		return self[start ..< end]
	}

	///  (Checks if String contains Email)
	public var isEmail: Bool {
		let dataDetector = try? NSDataDetector(types: NSTextCheckingType.Link.rawValue)
		let firstMatch = dataDetector?.firstMatchInString(self, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, length))
		return (firstMatch?.range.location != NSNotFound && firstMatch?.URL?.scheme == "mailto")
	}

	///  (Returns if String is a number)
	func isNumber() -> Bool {
		if let _ = NSNumberFormatter().numberFromString(self) {
			return true
		}
		return false
	}

	///  (Extracts URLS from String)
	public var extractURLs: [NSURL] {
		var urls: [NSURL] = []
		let detector: NSDataDetector?
		do {
			detector = try NSDataDetector(types: NSTextCheckingType.Link.rawValue)
		} catch _ as NSError {
			detector = nil
		}

		let text = self

		detector!.enumerateMatchesInString(text, options: [], range: NSMakeRange(0, text.characters.count), usingBlock: {
			(result: NSTextCheckingResult?, flags: NSMatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
			urls.append(result!.URL!)
		})

		return urls
	}
	/**
	 Check this string is pure integer or not
	 */
	func isPureInt() -> Bool {
		let scan: NSScanner = NSScanner(string: self as String)
		var val: Int = 0
		return scan.scanInteger(&val) && scan.atEnd
	}

	/**
	 Check this string is pure float or not
	 */
	func isPureDouble() -> Bool {
		let scan: NSScanner = NSScanner(string: self as String)
		var val: Double = 0.0
		return scan.scanDouble(&val) && scan.atEnd
	}

	/// Converts String to Int
	public func toInt() -> Int? {
		if let num = NSNumberFormatter().numberFromString(self) {
			return num.integerValue
		} else {
			return nil
		}
	}

	/// Converts String to Double
	public func toDouble() -> Double? {
		if let num = NSNumberFormatter().numberFromString(self) {
			return num.doubleValue
		} else {
			return nil
		}
	}

	/// Converts String to Float
	public func toFloat() -> Float? {
		if let num = NSNumberFormatter().numberFromString(self) {
			return num.floatValue
		} else {
			return nil
		}
	}

	/// Converts String to Bool
	func toBool() -> Bool? {
		let trimmed = self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).lowercaseString
		if trimmed == "true" || trimmed == "false" {
			return (trimmed as NSString).boolValue
		}
		return nil
	}

	/// Returns the first index of the occurency of the character in String
	public func getIndexOf(char: Character) -> Int? {
		for (index, c) in characters.enumerate() {
			if c == char {
				return index
			}
		}
		return nil
	}

	/// Converts String to NSString
	public var toNSString: NSString { get { return self as NSString } }

    // MARK: - NSAttributedString
    
	/// Returns bold NSAttributedString
	func bold() -> NSAttributedString {
		let boldString = NSMutableAttributedString(string: self, attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(UIFont.systemFontSize())])
		return boldString
	}

	/// Returns underlined NSAttributedString
	func underline() -> NSAttributedString {
		let underlineString = NSAttributedString(string: self, attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue])
		return underlineString
	}

	/// Returns italic NSAttributedString
	func italic() -> NSAttributedString {
		let italicString = NSMutableAttributedString(string: self, attributes: [NSFontAttributeName: UIFont.italicSystemFontOfSize(UIFont.systemFontSize())])
		return italicString
	}

	/// Returns NSAttributedString
	func color(color: UIColor) -> NSAttributedString {
		let colorString = NSMutableAttributedString(string: self, attributes: [NSForegroundColorAttributeName: color])
		return colorString
	}

}
