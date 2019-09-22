//
//  Recipe+Convenience.swift
//  Core-Data-AH
//
//  Created by Austin Potts on 9/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData


extension Recipe {
    
    //Computed property to initialize(return) the Representation of the Core Data Model
    var recipeRepresentation: RecipeRepresentation? {
        guard let title = title,
        let cuisine = cuisine,
         let directions = directions,
            let identifier = identifier?.uuidString else{return nil}
        return RecipeRepresentation(title: title, directions: directions, cuisine: cuisine, identifier: identifier)
    }
    
    
    
    
   
    convenience init(title: String, cuisine: String, directions: String, identifier: UUID = UUID(), context: NSManagedObjectContext ){
        self.init(context: context)
        self.title = title
        self.cuisine = cuisine
        self.directions = directions
        self.identifier = identifier
    }
    
    @discardableResult convenience init?(recipeRepresentation: RecipeRepresentation, context: NSManagedObjectContext) {
        guard let identifier = UUID(uuidString: recipeRepresentation.identifier) else {return nil}
        
        self.init(title: recipeRepresentation.title, cuisine: recipeRepresentation.cuisine, directions: recipeRepresentation.directions, identifier: identifier, context: context)
    }
    
    
}
