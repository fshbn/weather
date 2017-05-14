//
//  CityViewController.swift
//  Weather
//
//  Created by Boran ASLAN on 13/05/2017.
//  Copyright © 2017 Boran ASLAN. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {

    var viewModel: CityViewModel?
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cloudCoverageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeViewController()
    }
    
    fileprivate func observeViewController() {
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
            self.temperatureLabel.text = $0 + "°"
        }
        
        viewModel?.windSpeed.observe {
            [unowned self] in
            self.windSpeedLabel.text = $0
        }
        
        viewModel?.humidity.observe {
            [unowned self] in
            self.humidityLabel.text = $0
        }
        
        viewModel?.cloudCoverage.observe {
            [unowned self] in
            self.cloudCoverageLabel.text = $0
        }
    }
    
    func closeView() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        closeView()
    }
}
