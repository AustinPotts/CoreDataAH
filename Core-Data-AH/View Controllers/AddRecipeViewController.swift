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
    var pickerSelection: String?
    
    var recipeController: RecipeController?
    var recipe: Recipe?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        
        cuisinePicker.dataSource = self
        cuisinePicker.delegate = self
        
        pickerData = ["Thai", "Italian", "Mexican", "Japanese", "American", "Greek"]
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text,
            !title.isEmpty,
           let cuisine = pickerSelection,
            let directions = textView.text,
            !directions.isEmpty else{return}
        
        recipeController?.createRecipe(title: title, cuisine: cuisine, directions: directions)
        navigationController?.popViewController(animated: true)
    
    }
    
    func updateViews(){
        title = recipe?.title ?? "Create Recipe"
        
        titleTextField.text = recipe?.title
        
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       pickerSelection = pickerData[row]
    }
    
}
