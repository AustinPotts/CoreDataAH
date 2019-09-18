//
//  RecipeController.swift
//  Core-Data-AH
//
//  Created by Austin Potts on 9/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation


class RecipeController {
    
    //MARK: - Methods
    
    
    @discardableResult func createRecipe(title: String, cuisine: String, directions: String) -> Recipe {
        let recipe = Recipe(title: title, cuisine: cuisine, directions: directions, context: CoreDataStack.share.mainContext)
        
        CoreDataStack.share.saveToPersistentStore()
        
        return recipe
        
    }
    
    func deleteRecipe(recipe: Recipe) {
        CoreDataStack.share.mainContext.delete(recipe)
        CoreDataStack.share.saveToPersistentStore()
    }
    
    
    
    
}
