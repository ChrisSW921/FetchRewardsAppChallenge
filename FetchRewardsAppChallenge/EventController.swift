//
//  EventController.swift
//  FetchRewardsAppChallenge
//
//  Created by Chris Withers on 7/19/21.
//

import UIKit

enum NetworkingError: Error {
    case troubleDecoding
    case badURL
    case conditionalError
}

class EventController {
    
    static var shared = EventController()
    
    var events: [Event] = []
    
    let baseURL = "https://api.seatgeek.com/2/events"
    
    let clientSecret = "02420d95eff6b14aa016e7f6f327093bd182b966d37033c79c3133fb94d2bae4"
    
    let clientID = "MjI1ODM2OTN8MTYyNjcyMTY0MC43MzUy"
    
    
    func fetchEventsForSearchString(searchString: String, completion: @escaping (Result<Bool, NetworkingError>) -> Void) {
        
        let queryItems = [URLQueryItem(name: "q", value: searchString), URLQueryItem(name: "client_id", value: clientID), URLQueryItem(name: "client_secret", value: clientSecret)]
        
        var urlComps = URLComponents()
        urlComps.scheme = "https"
        urlComps.host = "api.seatgeek.com"
        urlComps.path = "/2/events"
        urlComps.queryItems = queryItems
        
        guard let url = urlComps.url else { return completion(.failure(.badURL)) }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            
            if let error = error {
                print("Error \(error.localizedDescription)")
                return completion(.failure(.conditionalError))
            }
            
            if let data = data {
                do {
                   let event = try JSONDecoder().decode(SearchResults.self, from: data)
                    self.events = []
                    self.events = event.events
                    return completion(.success(true))
                } catch {
                    print("Error decoding")
                    return completion(.failure(.troubleDecoding))
                }
            }
            
        }
        task.resume()
    }
    
    func fetchImageForEvent(event: Event, completion: @escaping(Result<UIImage, NetworkingError>) -> Void) {
        
        if event.performers.indices.count > 0 {
            let imagURLString = event.performers[0].image
            
            guard let url = URL(string: imagURLString) else { return completion(.failure(.badURL))}
            
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                
                if let error = error {
                    print("Error \(error.localizedDescription)")
                    return completion(.failure(.conditionalError))
                }
                
                if let data = data {
                    guard let image = UIImage(data: data) else { return completion(.failure(.troubleDecoding))}
                    return completion(.success(image))
                }
            }
            task.resume()
        } else {
            completion(.failure(.conditionalError))
        }
    }
    
}
