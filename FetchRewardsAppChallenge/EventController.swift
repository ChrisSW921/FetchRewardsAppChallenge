//
//  EventController.swift
//  FetchRewardsAppChallenge
//
//  Created by Chris Withers on 7/19/21.
//

import UIKit
import CoreData

enum NetworkingError: Error {
    case troubleDecoding
    case badURL
    case conditionalError
}

class EventController {
    
    static var shared = EventController()
    
    var events: [Event] = []
    
    var favorites: [Favorite] = []
    
    private lazy var fetchRequestForAll: NSFetchRequest<Favorite> = {
        let request = NSFetchRequest <Favorite>(entityName: "Favorite")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    func fetchAllFavorites() {
        favorites = (try? CoreDataStack.context.fetch(fetchRequestForAll)) ?? []
    }
    
    func addFavorite(id: String) {
        Favorite(id: id)
        CoreDataStack.saveContext()
        fetchAllFavorites()
    }
    
    func removeFavorite(id: String) {
        guard let favoriteToRemove = favorites.first(where: {$0.id == id}) else { return }
        guard let indexOfFavorite = favorites.firstIndex(where: {$0.id == id}) else { return }
        favorites.remove(at: indexOfFavorite)
        CoreDataStack.context.delete(favoriteToRemove)
        CoreDataStack.saveContext()
    }
    
    func isFavorited(id: String) -> Bool {
        for favorite in favorites {
            if favorite.id == id {
                return true
            }
        }
        return false
    }
    
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
            
            if let _ = error {
                return completion(.failure(.conditionalError))
            }
            
            if let data = data {
                do {
                   let event = try JSONDecoder().decode(SearchResults.self, from: data)
                    self.events = []
                    self.events = event.events
                    return completion(.success(true))
                } catch {
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
                
                if let _ = error {
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
