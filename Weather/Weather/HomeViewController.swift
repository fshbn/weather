//
//  HomeViewController.swift
//  Weather
//
//  Created by Boran ASLAN on 12/05/2017.
//  Copyright © 2017 Boran ASLAN. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
        viewModel?.startLocationService()
    }
    
    // MARK: ViewModel
    var viewModel: HomeViewModel? {
        didSet {
            viewModel?.location.observe {
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
        }
    }

    
}
