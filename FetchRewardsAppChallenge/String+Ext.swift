//
//  String+Ext.swift
//  FetchRewardsAppChallenge
//
//  Created by Chris Withers on 7/20/21.
//

import Foundation

extension String {
    func convertToDate() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"

        if let date = dateFormatterGet.date(from: self) {
            return dateFormatter.string(from: date)
        } else {
           print("There was an error decoding the string")
        }
        return "No date available"
    }
}
