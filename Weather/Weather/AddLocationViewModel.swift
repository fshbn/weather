//
//  AddLocationViewModel.swift
//  Weather
//
//  Created by Boran ASLAN on 13/05/2017.
//  Copyright © 2017 Boran ASLAN. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit

class AddLocationViewModel {
    
    var managedObjectContext: NSManagedObjectContext?
    
    // MARK: - init
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
    }
    
    // MARK: - public
    func saveBookmark(coordinate: CLLocationCoordinate2D) {
        let bookmark = NSEntityDescription.insertNewObject(forEntityName: "Bookmark", into: self.managedObjectContext!) as! BookmarkModel
        bookmark.lat = coordinate.latitude
        bookmark.lon = coordinate.longitude
        do {
            try self.managedObjectContext?.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
}

