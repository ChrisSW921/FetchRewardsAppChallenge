//
//  Event.swift
//  FetchRewardsAppChallenge
//
//  Created by Chris Withers on 7/19/21.
//

import Foundation

struct SearchResults: Decodable {
    let events: [Event]
}

struct Event: Decodable {
    let id: Int
    let date_tbd: Bool
    let time_tbd: Bool
    let datetime_local: String
    let datetime_utc: String
    let title: String
    let performers: [Performers]
    let venue: Venue
}

struct Venue: Decodable {
    let address: String
    let city: String
    let state: String
    let name: String
    
}

struct Performers: Decodable {
    let image: String
}
