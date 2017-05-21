//
//  LocalStorageProtocol.swift
//  Weather
//
//  Created by Boran ASLAN on 21/05/2017.
//  Copyright © 2017 Boran ASLAN. All rights reserved.
//

import Foundation

typealias BookmarksCompletionHandler = ([AnyObject]?, WeatherError?) -> Void

protocol LocalDataProtocol {
    func getBookmarkedCities(predicate: NSPredicate?, completionHandler: @escaping BookmarksCompletionHandler)
    func saveBookmarkedCity(bookmark: BookmarkModel?, completionHandler: @escaping BookmarksCompletionHandler)
    func deleteBookmarkedCity(bookmark: BookmarkModel?, completionHandler: @escaping BookmarksCompletionHandler)
}
