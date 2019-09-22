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
    
    
    func fetchTaskFromServer(completion: @escaping()-> Void = {}) {
        
        
        
        let requestURL = fireBaseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error{
                NSLog("error fetching tasks: \(error)")
                completion()
            }
            
            guard let data = data else{
                NSLog("Error getting data task:")
                completion()
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                //Gives us full array of task representation
                let recipeRepresentations = Array(try decoder.decode([String: RecipeRepresentation].self, from: data).values)
                
                self.update(with: recipeRepresentations)
                
                
                
            } catch {
                NSLog("Error decoding: \(error)")
                
            }
            
            }.resume()
        
        
    }
    
    func update(with representations: [RecipeRepresentation]){
        
        
        let identifiersToFetch = representations.compactMap({ UUID(uuidString: $0.identifier)})
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        //Make a mutable copy of Dictionary above
        var tasksToCreate = representationsByID
        
        
        let context = CoreDataStack.share.container.newBackgroundContext()
        context.performAndWait {
            
            
            
            do {
                
                let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
                //Name of Attibute
                fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
                
                //Which of these tasks already exist in core data?
                let exisitingRecipe = try context.fetch(fetchRequest)
                
                //Which need to be updated? Which need to be put into core data?
                for recipe in exisitingRecipe {
                    guard let identifier = recipe.identifier,
                        // This gets the task representation that corresponds to the task from Core Data
                        let representation = representationsByID[identifier] else{return}
                    
                    recipe.title = representation.title
                    recipe.cuisine = representation.cuisine
                    recipe.directions = representation.directions
                    
                    tasksToCreate.removeValue(forKey: identifier)
                    
                }
                //Take these tasks that arent in core data and create
                for representation in tasksToCreate.values{
                    Recipe(recipeRepresentation: representation, context: context)
                }
                
                CoreDataStack.share.save(context: context)
                
            } catch {
                NSLog("Error fetching tasks from persistent store: \(error)")
            }
        }
        
    }
    
    
    
    
    
    
    
    @discardableResult func createRecipe(title: String, cuisine: String, directions: String) -> Recipe {
        let recipe = Recipe(title: title, cuisine: cuisine, directions: directions, context: CoreDataStack.share.mainContext)
        
        put(recipe: recipe)
        CoreDataStack.share.save()
        
        return recipe
        
    }
    
    func updateRecipe(recipe: Recipe, with title: String, cuisine: String, directions: String){
        recipe.title = title
        recipe.cuisine = cuisine
        recipe.directions = directions
        
        put(recipe: recipe)
        CoreDataStack.share.save()
    }
    
    func deleteRecipe(recipe: Recipe) {
        CoreDataStack.share.mainContext.delete(recipe)
        CoreDataStack.share.save()
    }
    
    
    
    
}
