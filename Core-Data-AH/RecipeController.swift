//
//  RecipeController.swift
//  Core-Data-AH
//
//  Created by Austin Potts on 9/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String{
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class RecipeController {
    
    //MARK: - Methods
    
    let fireBaseURL = URL(string: "https://recipes-e7b18.firebaseio.com/")!
    
    func put(recipe: Recipe, completion: @escaping()-> Void = {}) {
        
        let identifer = recipe.identifier ?? UUID()
        recipe.identifier = identifer
        
        let requestURL = fireBaseURL.appendingPathComponent(identifer.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let recipeRepresentation = recipe.recipeRepresentation else{
            NSLog("Error")
            completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(recipeRepresentation)
        } catch {
            NSLog("Error Encoding Rep: \(error)")
            completion()
            return
            
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error{
                NSLog("Error putting task: \(error)")
                completion()
                return
            }
            completion()
            }.resume()
        
        
    }
    
    
    
    
    
    
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
