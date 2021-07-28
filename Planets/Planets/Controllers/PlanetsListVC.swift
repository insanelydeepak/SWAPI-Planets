//
//  PlanetsListVC.swift
//  Planets
//
//  Created by Mithlesh (InsanelyDeepak) on 27/07/21.
//  Copyright © 2021 Mithlesh Kumar. All rights reserved.
//

import UIKit

class PlanetsListVC: UIViewController {
    // MARK: - Variables and Properties
    
    @IBOutlet weak var tblView: UITableView!
    private var viewModel: PlanetsViewModel?
    
    // MARK: - Lifecycles    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel = PlanetsViewModel(delegate: self)
    }
    
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchPeople()        
    }
    
    private func setupUI() {
        showLoader()        
        
        tblView.tableFooterView = UIView()
        tblView.register(PlanetCell.self, forCellReuseIdentifier: PlanetCell.reuseIdentifier)
    }
}
// MARK: - TableView Delegate and Datasource

extension PlanetsListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let detailVC = storyboard?.instantiateViewController(identifier: "PlanetDetailVC") as? PlanetDetailVC else { return }
        detailVC.planet = viewModel?.findPlanet(at: indexPath.row)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.totalCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlanetCell.reuseIdentifier, for: indexPath) as? PlanetCell else { fatalError("Error dequeuing CharacterCell") }
        /*
          Load an empty cell if it is waiting for data from API call.
          This allows the TableView to load in real time behind the blurred loading view
          and leads to a better user experience for long network calls.
         */
        if !isLoadingCell(for: indexPath) {
            cell.planet = viewModel?.findPlanet(at: indexPath.row)
        }
        return cell
    }
}

// MARK: - PlanetsViewModelDelegate

extension PlanetsListVC: PlanetsViewModelDelegate {
    func fetchDidSucceed() {
        // Reload table view with fetched planets
        tblView.reloadData()
        
        // Remove the loading view when all planets have been fetched
        guard let status = viewModel?.allPlanetsFetched else {
            removeLoader()
            return
        }
        if (status){            
            removeLoader()
        }
    }
    
    func fetchDidFail(with description: String) {
        removeLoader()
        self.showAlertViewWithTitle(title: AlertKey.FAILURE, message: description)
    }
}

// MARK: - Internal Methods

private extension PlanetsListVC {
    // Checks if index path row exceeds what is currently loaded
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel?.currentCount ?? 0
    }
}
