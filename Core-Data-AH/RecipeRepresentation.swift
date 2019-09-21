//
//  RecipeRepresentation.swift
//  Core-Data-AH
//
//  Created by Austin Potts on 9/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation


struct RecipeRepresentation: Codable {
    
    let title: String
    let directions: String
    let cuisine: String
    let identifer: String
    
}
