//
//  HomeViewModel.swift
//  Weather
//
//  Created by Boran ASLAN on 12/05/2017.
//  Copyright © 2017 Boran ASLAN. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData
import UIKit

class HomeViewModel {
    
    // MARK: - Properties
    let locationName: Observable<String>
    let iconText: Observable<String>
    let temperature: Observable<String>
    let bookmarkedLocations: Observable<[Weather]>
    let errorMessage: Observable<String?>
    
    var userLastLocation: CLLocation
    var managedObjectContext: NSManagedObjectContext
    var bookmarks: [Weather]
    
    // MARK: - Services
    fileprivate var locationService: LocationService
    fileprivate var weatherService: ServiceProtocol
    
    // MARK: - init
    init() {
        locationName = Observable(emptyString)
        iconText = Observable(emptyString)
        temperature = Observable(emptyString)
        bookmarkedLocations = Observable([])
        errorMessage = Observable(nil)
        
        userLastLocation = CLLocation(latitude: 0, longitude: 0)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        bookmarks = [Weather]()
        
        locationService = LocationService()
        weatherService = OpenWeatherMapService()
    }
    
    // MARK: - public
    func startLocationService() {
        locationService.delegate = self
        locationService.requestLocation()
    }
    
    func updateBookmarks() {
        self.bookmarks = [Weather]()
        
        let bookmarkModels = fetchBookmarksWith(predicate: nil)
        for bookmarkModel in bookmarkModels {
            let location = CLLocation(latitude: bookmarkModel.lat, longitude: bookmarkModel.lon)
            
            weatherService.retrieveWeatherInfo(location) { weather, error -> Void in
                if let unwrappedError = error {
                    self.updateBookmarks(unwrappedError)
                    return
                }
                
                guard let unwrappedWeather = weather else {
                    return
                }
                
                if bookmarkModel.name == nil && bookmarkModel.cityId == 0 {
                    bookmarkModel.name = unwrappedWeather.cityName
                    bookmarkModel.cityId = unwrappedWeather.cityId
                    
                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
                
                self.bookmarks.append(unwrappedWeather)
                DispatchQueue.main.async(execute: {
                    self.updateBookmarks(self.bookmarks)
                })
            }
        }
    }
    
    func deleteBookmarked(weather: Weather) {
        let bookmarkModels = fetchBookmarksWith(predicate: NSPredicate(format: "cityId == %i", weather.cityId))
        
        for bookmark in bookmarkModels {
            managedObjectContext.delete(bookmark)
        }
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }

        self.bookmarks = self.bookmarks.filter{$0.cityId != weather.cityId}
        DispatchQueue.main.async(execute: {
            self.updateBookmarks(self.bookmarks)
        })
    }
    
    // MARK: - private
    fileprivate func updateWeather(_ weather: Weather) {
        self.locationName.value = weather.cityName
        self.iconText.value = weather.icon
        self.temperature.value = String(format: "%.0f", weather.temperature) + "°"
    }
    
    fileprivate func updateWeather(_ error: WeatherError) {
        self.errorMessage.value = error.rawValue
        
        self.locationName.value = emptyString
        self.iconText.value = emptyString
        self.temperature.value = emptyString
    }
    
    // MARK: - private
    fileprivate func updateBookmarks(_ weathers: [Weather]) {
        self.bookmarkedLocations.value = weathers
    }
    
    fileprivate func updateBookmarks(_ error: WeatherError) {
        self.errorMessage.value = error.rawValue
        
        self.bookmarkedLocations.value = []
    }
    
    fileprivate func fetchBookmarksWith(predicate: NSPredicate?) -> [BookmarkModel] {
        let bookmarkFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Bookmark")
        if let predicate = predicate {
            bookmarkFetch.predicate = predicate
        }
        
        do {
            let fetchedBookmarks = try self.managedObjectContext.fetch(bookmarkFetch) as! [BookmarkModel]
            return fetchedBookmarks
        } catch {
            fatalError("Failed to fetch bookmarks: \(error)")
        }
    }
}

// MARK: LocationServiceDelegate
extension HomeViewModel: LocationServiceDelegate {
    func locationDidUpdate(_ service: LocationService, location: CLLocation) {
        userLastLocation = location
        weatherService.retrieveWeatherInfo(location) { weather, error -> Void in
            DispatchQueue.main.async(execute: {
                if let unwrappedError = error {
                    self.updateWeather(unwrappedError)
                    return
                }
                
                guard let unwrappedWeather = weather else {
                    return
                }
                
                self.updateWeather(unwrappedWeather)
            })
        }
    }
}
