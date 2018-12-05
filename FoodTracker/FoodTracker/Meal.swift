//
//  Meal.swift
//  FoodTracker
//
//  Created by Tal on 04/12/2018.
//  Copyright © 2018 Tal. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding{
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Archiving Paths
    
    //get the documents directory
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    
    //create url for meals in this directory
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")

    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    init?(name: String, photo: UIImage?, rating: Int){
        // The name must not be empty
        guard !name.isEmpty else{
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
        
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    
    //convinience initializer means its a secondary initializer and it must call a designated initializer
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        //photo is optional so guard is not needed
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        //a convinience initializer must call designated initializer!
        self.init(name: name, photo: photo, rating: rating)
    }

}
