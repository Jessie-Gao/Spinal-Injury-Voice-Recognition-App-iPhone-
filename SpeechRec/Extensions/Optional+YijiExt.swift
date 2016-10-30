//
//  Optional+YijiExt.swift
//
// Copyright (c) 2016 


import Foundation


extension Optional: BooleanType {
    /// Gets the boolean value of an optional。 For all .None or nil values return false. Otherwise return true
    public var boolValue: Bool {
        switch self {
        case .None:
            return false
        case .Some(let wrapped):
            if let booleanable = wrapped as? BooleanType {
                return booleanable.boolValue
            }
            return true
        }
    }
}



/**
 *  text contain
 */
protocol TextContaining {
    var isEmpty: Bool { get}
}

extension String: TextContaining { }


extension Optional where Wrapped: TextContaining {
    /// whether it is empty
    var isEmpty: Bool {
        switch self {
        case let .Some(value):
            return value.isEmpty
        case .None:
            return true
        }
    }
}

extension String: BooleanType {
    // MARK: - Empty
    /**
     whether empty `Optional.isEmpty`
     
     usage:
     
     ```
     if "" {
        print("yes")
        // this code will not be executed
     } else {
        print("no")
        // this code will be executed
     }
     ```
     
     */
    public var boolValue: Bool {
        return !self.isEmpty
    }
}
