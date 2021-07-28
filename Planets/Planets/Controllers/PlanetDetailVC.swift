//
//  PlanetDetailVC.swift
//  Planets
//
//  Created by Mithlesh (InsanelyDeepak) on 28/07/21.
//  Copyright © 2021 Mithlesh Kumar. All rights reserved.
//

import UIKit

class PlanetDetailVC: UIViewController {
    
    // MARK: - Variables and Properties
    
    @IBOutlet weak var tblView: UITableView!
    private var viewModel: PlanetsViewModel?
    
    var residents: [Resident] = []
    var planet: Planet?
    var residentString: String = ""
    
       
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PlanetsViewModel(delegate: self)
        planet?.residents.forEach { filmUrl in
            viewModel?.fetchFilm(with: filmUrl)
        }
        
        setupTitleView()
        setupTableView()
    }
    
           
    private func setupTableView() {
        tblView.tableFooterView = UIView()
        tblView.register(PlanetDetailCell.nib, forCellReuseIdentifier: PlanetDetailCell.reuseIdentifier)
    }
   
    private func setupTitleView() {
        self.title =  planet?.name
    }
}
// MARK: - PlanetsViewModel

extension PlanetDetailVC: PlanetsViewModelDelegate {
    func fetchDidSucceed() {
        // Update the UI if all the film data has been fetched
        let residents = viewModel?.findResidents()
        guard planet?.residents.count == residents?.count else { return }
        
        // For every film, create a string with its title and opening crawl word count
        // Create a separate line for each film
        residentString = residents?.map {
            "\($0.name) " + "(\($0.gender))"
        }.joined(separator: "\n\n") ?? ""
        
        tblView.reloadData()
    }
    
    func fetchDidFail(with description: String) {
        showAlertViewWithTitle(title: AlertKey.FAILURE, message: description)
    }    
}

// MARK: - TableView Delegate and Datasource

extension PlanetDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Attributes.getCount()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       let title =  Attributes(rawValue: section)?.title
        
        return title;
    }
  
    
    // MARK: - Rows
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlanetDetailCell.reuseIdentifier, for: indexPath) as? PlanetDetailCell else { fatalError("Error dequeuing cell") }
        
        if let _planet = planet {
            switch Attributes.getSection(indexPath.section) {
            case .rotation_period: cell.configureCell(with: _planet.rotationPeriod)
            case .orbital_period: cell.configureCell(with: _planet.orbitalPeriod)
            case .diameter: cell.configureCell(with: _planet.diameter)
            case .gravity: cell.configureCell(with: _planet.gravity)
            case .terrain: cell.configureCell(with: _planet.terrain)
            case .surface_water: cell.configureCell(with: _planet.surfaceWater)
            case .population: cell.configureCell(with: _planet.population)
                
            case .residents:
                cell.configureCell(with: residentString)
                cell.loadingIndicator.isHidden = false
                cell.loadingIndicator.startAnimating()
                
                // Remove loading indicator when residents are loaded
                if residentString.count > 0 {
                    cell.loadingIndicator.stopAnimating()
                }
            }
            
        }
        
        
        return cell
    }
}
