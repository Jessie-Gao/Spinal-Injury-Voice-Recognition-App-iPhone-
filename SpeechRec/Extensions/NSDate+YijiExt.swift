
//
//  NSDate+YijiExt.swift
//
// Copyright (c) 2016 

import Foundation

public extension NSDate {
    /**
     start time
     */
	func firstDateInThisWeek() -> NSDate {
		var beginningOfWeek: NSDate?
		let calendar = NSCalendar.currentCalendar()
		calendar.rangeOfUnit(.WeekOfYear, startDate: &beginningOfWeek, interval: nil, forDate: self)
		return beginningOfWeek!
	}
    /**
     whether in this week
     */
	func isInCurrentWeek() -> Bool {
		let firstDateOfWeek = NSDate().firstDateInThisWeek()

		if self.compare(firstDateOfWeek) == .OrderedDescending {
			return true
		}

		return false
	}

    
	class func dateWithISO08601String(dateString: String?) -> NSDate {
		if let dateString = dateString {
			var dateString = dateString

			if dateString.hasSuffix("Z") {
				dateString = String(dateString.characters.dropLast()).stringByAppendingString("-0000")
			}

			return dateFromString(dateString, withFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
		}

		return NSDate()
	}

    /**
     
     - parameter dateString: time string
     - parameter dateFormat: date
     
     - returns: convert date
     */
	class func dateFromString(dateString: String, withFormat dateFormat: String) -> NSDate {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = dateFormat
		if let date = dateFormatter.dateFromString(dateString) {
			return date
		} else {
			return NSDate()
		}
	}
}

public extension NSDate {
    
	func timeAgoSinceNow() -> String {
		return timeAgoSinceDate(self, numericDates: true)
	}
    
    
	private func timeAgoSinceDate(date: NSDate, numericDates: Bool) -> String {

		let calendar = NSCalendar.currentCalendar()
		let unitFlags: NSCalendarUnit = [.Year, .Month, .WeekOfYear, .Day, .Hour, .Minute, .Second]
		let now = NSDate()
		let earliest = now.earlierDate(date)
		let latest = earliest == now ? date : now
		let components = calendar.components(unitFlags, fromDate: earliest, toDate: latest, options: [])

		switch components {
		case components.year >= 2:
			return "\(components.year)before year"
		case components.year >= 1:
			return numericDates ? "1 year before" : "last year"
		case components.month >= 2:
			return "\(components.day)before month"
		case components.month >= 1:
			return numericDates ? "1 month before" : "last month"
		case components.weekOfYear >= 2:
			return "\(components.weekOfYear)before week"
		case components.weekOfYear >= 1:
			return numericDates ? "1 week before" : "last week"
		case components.day >= 2:
			return "\(components.day)before day"
		case components.day >= 1:
			return numericDates ? "1 day before" : "yesterday"
		case components.hour >= 2:
			return "\(components.hour)before hour"
		case components.hour >= 1:
			return numericDates ? "1 hour before" : "last hour"
		case components.minute >= 2:
			return "\(components.minute)before minute"
		case components.minute >= 1:
			return numericDates ? "1 minute before" : "last minute"
		case components.second >= 3:
			return "\(components.second)before second"
		default:
			return "just now"
		}
	}

    /**
     convert string to date
     
     - parameter stringData: string
     - returns: date
     */
	class func convertFromString(stringData: String) -> NSDate? {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"

		let date = dateFormatter.dateFromString(stringData)
		return date
	}
    
    /**
     convert to string
     
     - returns: string  formate：YYYY-MM-dd HH:mm:ss
     */
	func convertToString() -> String {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"

		let dateString = dateFormatter.stringFromDate(self)
		return dateString
	}

    
    func convertToShortString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let dateString = dateFormatter.stringFromDate(self)
        return dateString
    }

	
	func toString(format: String) -> String {

		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = format

		let dateString = dateFormatter.stringFromDate(self)
		return dateString
	}

}
