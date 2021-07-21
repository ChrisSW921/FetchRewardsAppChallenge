//
//  Favorite+Convenience.swift
//  FetchRewardsAppChallenge
//
//  Created by Chris Withers on 7/19/21.
//

import Foundation
import CoreData

extension Favorite {
    
    @discardableResult convenience init(id: String, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.id = id
    }
    
    
}
