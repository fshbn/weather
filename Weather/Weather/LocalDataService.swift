//
//  LocalDataService.swift
//  Weather
//
//  Created by Boran ASLAN on 21/05/2017.
//  Copyright © 2017 Boran ASLAN. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct LocalDataService: LocalDataProtocol {
    
    func getBookmarkedCities(predicate: NSPredicate?, completionHandler: @escaping BookmarksCompletionHandler) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        let bookmarkFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Bookmark")
        if let predicate = predicate {
            bookmarkFetch.predicate = predicate
        }
        
        do {
            let fetchedBookmarks = try managedObjectContext.fetch(bookmarkFetch) as! [BookmarkModel]
            completionHandler(fetchedBookmarks, nil)
        } catch {
            completionHandler(nil, WeatherError.dataError)
        }
    }
    
    func saveBookmarkedCity(bookmark: BookmarkModel?, completionHandler: @escaping BookmarksCompletionHandler) {

    }
    
    func deleteBookmarkedCity(bookmark: BookmarkModel?, completionHandler: @escaping BookmarksCompletionHandler) {

    }
    
}
