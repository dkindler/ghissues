//
//  Date+Helper.swift
//  ghissues
//
//  Created by Dan Kindler on 5/1/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import Foundation

extension Date {
    static func from(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: string)
    }
}
