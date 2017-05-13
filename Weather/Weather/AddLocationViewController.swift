//
//  AddLocationViewController.swift
//  Weather
//
//  Created by Boran ASLAN on 13/05/2017.
//  Copyright © 2017 Boran ASLAN. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class AddLocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var userLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.showsUserLocation = true
        
        let regionRadius = 10000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, CLLocationDistance(regionRadius), CLLocationDistance(regionRadius))
        self.mapView.setRegion( coordinateRegion, animated: true)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotationOnLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 1.0
        self.mapView.addGestureRecognizer(longPressGesture)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
    }
    
    func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: self.mapView)
            let coordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
            
            let alert = UIAlertController(title: "New Location", message: "We're adding this place to your bookmarks?", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.destructive, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Yes, please", style: UIAlertActionStyle.default, handler: { action in
                
                let bookmark = NSEntityDescription.insertNewObject(forEntityName: "Bookmark", into: self.managedObjectContext!) as! BookmarkModel
                bookmark.lat = coordinate.latitude
                bookmark.lon = coordinate.longitude
                
                do {
                    try self.managedObjectContext?.save()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
                
                self.closeView()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func closeView() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        closeView()
    }
    
}
