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
    // MARK: - Constants
    fileprivate let emptyString = ""
    
    // MARK: - Properties
    let hasError: Observable<Bool>
    let errorMessage: Observable<String?>
    
    let locationName: Observable<String>
    let iconText: Observable<String>
    let temperature: Observable<String>
    let bookmarkedLocations: Observable<[Weather]>
    
    var userLastLocation: CLLocation
    var managedObjectContext: NSManagedObjectContext
    var bookmarks: [Weather]
    
    // MARK: - Services
    fileprivate var locationService: LocationService
    fileprivate var weatherService: ServiceProtocol
    
    // MARK: - init
    init() {
        hasError = Observable(false)
        errorMessage = Observable(nil)
        
        locationName = Observable(emptyString)
        iconText = Observable(emptyString)
        temperature = Observable(emptyString)
        bookmarkedLocations = Observable([])
        userLastLocation = CLLocation(latitude: 0, longitude: 0)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        bookmarks = [Weather]()
        
        // Can put Dependency Injection here
        locationService = LocationService()
        weatherService = OpenWeatherMapService()
    }
    
    // MARK: - public
    func startLocationService() {
        locationService.delegate = self
        locationService.requestLocation()
    }
    
    func updateBookmarks() {
        fetchBoorkmarks()
    }
    
    // MARK: - private
    fileprivate func updateWeather(_ weather: Weather) {
        //        hasError.value = false
        //        errorMessage.value = nil
        //
        locationName.value = weather.location
        iconText.value = weather.iconText
        temperature.value = weather.temperature
    }
    
    fileprivate func updateWeather(_ error: Error) {
        //        hasError.value = true
        //
        //        switch error.errorCode {
        //        case .urlError:
        //            errorMessage.value = "The weather service is not working."
        //        case .networkRequestFailed:
        //            errorMessage.value = "The network appears to be down."
        //        case .jsonSerializationFailed:
        //            errorMessage.value = "We're having trouble processing weather data."
        //        case .jsonParsingFailed:
        //            errorMessage.value = "We're having trouble parsing weather data."
        //        }
        //
        locationName.value = emptyString
        iconText.value = emptyString
        temperature.value = emptyString
    }
    
    // MARK: - private
    fileprivate func updateBookmarks(_ weathers: [Weather]) {
        //        hasError.value = false
        //        errorMessage.value = nil
        //
        DispatchQueue.main.async(execute: {
            self.bookmarkedLocations.value = weathers
        })
    }
    
    fileprivate func updateBookmarks(_ error: Error) {
        //        hasError.value = true
        //
        //        switch error.errorCode {
        //        case .urlError:
        //            errorMessage.value = "The weather service is not working."
        //        case .networkRequestFailed:
        //            errorMessage.value = "The network appears to be down."
        //        case .jsonSerializationFailed:
        //            errorMessage.value = "We're having trouble processing weather data."
        //        case .jsonParsingFailed:
        //            errorMessage.value = "We're having trouble parsing weather data."
        //        }
        //
        bookmarkedLocations.value = []
    }
    
    fileprivate func fetchBoorkmarks() {
        self.bookmarks = [Weather]()
        let bookmarkFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Bookmark")
        
        do {
            let fetchedBookmarks = try self.managedObjectContext.fetch(bookmarkFetch) as! [BookmarkModel]
            for bookmark in fetchedBookmarks {
                let location = CLLocation(latitude: bookmark.lat, longitude: bookmark.lon)
                
                weatherService.retrieveWeatherInfo(location) { weather, error -> Void in
                    if let unwrappedError = error {
                        self.updateBookmarks(unwrappedError)
                        return
                    }
                    
                    guard let unwrappedWeather = weather else {
                        return
                    }
                    
                    bookmark.name = unwrappedWeather.location
                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                    
                    self.bookmarks.append(unwrappedWeather)
                    
                    self.updateBookmarks(self.bookmarks)
                }
            }
            print(fetchedBookmarks)
        } catch {
            fatalError("Failed to fetch employees: \(error)")
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
                    print(unwrappedError)
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
