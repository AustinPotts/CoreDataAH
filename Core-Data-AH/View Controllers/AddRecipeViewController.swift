//
//  AddRecipeViewController.swift
//  Core-Data-AH
//
//  Created by Austin Potts on 9/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var cuisinePicker: UIPickerView!
    @IBOutlet weak var textView: UITextView!
    
    var pickerData: [String] = []
    var recipeController: RecipeController?
    var recipe: Recipe?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cuisinePicker.dataSource = self
        cuisinePicker.delegate = self
        
        pickerData = ["Thai", "Italian", "Mexican", "Japanese", "American", "Greek"]
    }
    
    @IBAction func save(_ sender: Any) {
    
    
    }
    
   
    
  

}


extension AddRecipeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
}
