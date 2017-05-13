//
//  HomeViewController.swift
//  Weather
//
//  Created by Boran ASLAN on 12/05/2017.
//  Copyright © 2017 Boran ASLAN. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
        viewModel?.startLocationService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.updateBookmarks()
    }
    
    // MARK: ViewModel
    var viewModel: HomeViewModel? {
        didSet {
            viewModel?.locationName.observe {
                [unowned self] in
                self.locationLabel.text = $0
            }
            
            viewModel?.iconText.observe {
                [unowned self] in
                self.iconLabel.text = $0
            }
            
            viewModel?.temperature.observe {
                [unowned self] in
                self.temperatureLabel.text = $0
            }
            
            viewModel?.bookmarkedLocations.observe {
                [unowned self] (Weather) in
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.bookmarkedLocations.value.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkTableViewCell", for: indexPath) as! BookmarkTableViewCell
        
        let weather = viewModel?.bookmarkedLocations.value[indexPath.row]
        
        cell.nameLabel.text = weather?.location
        cell.temperatureLabel.text = weather?.temperature
        cell.iconLabel.text = weather?.iconText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            viewModel?.deleteBookmarkAt(indexPath: indexPath)
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocationSegue" {
            let destinationViewController = segue.destination as! AddLocationViewController
            if let userLocation = viewModel?.userLastLocation {
                destinationViewController.viewModel = AddLocationViewModel()
                destinationViewController.userLocation = userLocation
            }
        }
        
        if segue.identifier == "citySegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let row = indexPath.row
                let cityViewModel = CityViewModel(weather: (viewModel?.bookmarkedLocations.value[row])!)
                let destinationViewController = segue.destination as! CityViewController
                destinationViewController.viewModel = cityViewModel
            }
        }
    }
}
