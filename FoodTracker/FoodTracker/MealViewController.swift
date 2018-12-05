//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Tal on 03/12/2018.
//  Copyright © 2018 Tal. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController , UITextFieldDelegate ,
UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //MARK: Properties
    
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var RatingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var meal: Meal?
    
    
    //view controller is the delegate of nameTextField
    override func viewDidLoad() {
        super.viewDidLoad()
        //        nameTextField.delegate = self
        nameTextField.delegate = self
        
        if let meal = meal{
            navigationItem.title = meal.name
            nameTextField.text   = meal.name
            photoImageView.image = meal.photo
            RatingControl.rating = meal.rating
        }
        
        //make sure the save button disabled until user start typing (then control goes to didBeginEditing
        updateSaveButtonState()
    }
    
    

    
    //MARK: UITextFieldDelegate
    
    //indicates if the system should process the press of the return key.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        //makes textField resign, hide the keyboard
        textField.resignFirstResponder()
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    //Being called right after textField resign
    //Change mealNameLabel text after user finished inserting input
    func textFieldDidEndEditing(_ textField: UITextField){
        updateSaveButtonState()
        
        //set the title to be the user input
        navigationItem.title = textField.text
        
    }

    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        //if cant be UIImage after casting, raise fatalError
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }

        //set the selected image
        photoImageView.image = selectedImage
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //check if the presenting controller is an UINav controller, if so, it means that addMeal button was selected (beacuse its embedded in its own nav controller, which presents it)
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        //if so, dismiss
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
            
        //if its not the presenting controller but its inside a nav controller, that means its in the stack of the navigation controller.
        //safely unwrap the nav controller and pop this view controller (its pushed when user clicked the meal)
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = RatingControl.rating
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        meal = Meal(name: name, photo: photo, rating: rating)
        
    }
    
    
    //MARK: Actions
    
    //when a user tap the image
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        //make sure keyboard is hidden
        nameTextField.resignFirstResponder()
        //create image picker controller
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    //MARK: Private Methods
    
    //check if the input meal name is empty and set the save button state accordingly
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}

