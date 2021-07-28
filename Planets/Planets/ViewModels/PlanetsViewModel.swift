//
//  PlanetsViewModel.swift
//  Planets
//
//  Created by Mithlesh (InsanelyDeepak) on 28/07/21.
//  Copyright © 2021 Mithlesh Kumar. All rights reserved.
//

import UIKit
protocol PlanetsViewModelDelegate: AnyObject {
    func fetchDidSucceed()
    func fetchDidFail(with description: String)
}
// Final Declaration to prevent inheritance from other classes
final class PlanetsViewModel {
    private weak var delegate: PlanetsViewModelDelegate?
    
    // MARK: - Initializers
    
    init(delegate: PlanetsViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Variables and Properties
    
    var apiClient = APIClient()
    
    private var residents: [Resident] = []
    private var listPeople: [Planet] = [] {
        didSet {
            // Keep track of fetched planets and compare with total on server
            // Fetch next page of results until all planets are fetched
            if self.currentPage < 6 {
                // Note:
                // restricted to 6 pages only
                // to fill the initial screen
                //
                
                fetchPeople()
            } else {
                
                // When all planets are fetched, sort alphabetically,
                // and reload table view with data
                allPlanetsFetched = true
                saveSession()
                self.listPeople.sort { $0.name < $1.name }
                self.delegate?.fetchDidSucceed()
            }
        }
    }
    
    private var currentPage = 1
    private var total = 0
    var currentCount: Int { return listPeople.count }
    var totalCount: Int {
        return total
    }
    var allPlanetsFetched: Bool = false
    
    
    // MARK: - Internal Methods
    func findPlanet(at index: Int) -> Planet {
        return listPeople[index]
    }
    func findResidents() -> [Resident] {
        return residents
    }
    func saveSession(){
        let rootResponse = RootResponse(count: self.total, next: nil, previous: nil, results: listPeople)
        let session: Data = try! JSONEncoder().encode(rootResponse)
        UtilityHelper.saveSessionToDisk(session)
    }
    func loadSession() -> Bool{
        if let data: Data = UtilityHelper.loadSessionFromDisk() {
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(RootResponse.self, from: data)
                
                self.total = response.count
                
                // Note:
                // to prevent further page loaing
                //
                self.currentPage = 6
                
                // Clean previous data
                listPeople.removeAll()
                
                // Store the latest fetched planets
                self.listPeople.append(contentsOf: response.results)
                self.delegate?.fetchDidSucceed()
                
                return true
            } catch {
                print("loadSession:: error")
            }
        }
        return false
    }
    
    // MARK: - Fetch Data
    func fetchPeople() {
        let session_success = loadSession()
        if !session_success {
            if (UtilityHelper.isInternetAvailable()){
                apiClient.fetch(with: nil, page: currentPage, dataType: RootResponse.self) { result in
                    switch result {
                    case .failure(let error):
                        // Perform on main thread to update UI
                        DispatchQueue.main.async {
                            self.delegate?.fetchDidFail(with: error.reason)
                        }
                    case .success(let response):
                        // Perform on main thread to update UI
                        DispatchQueue.main.async { [self] in
                            // Store total number of planets available on the server
                            self.total = response.count
                            self.currentPage += 1
                            // Store the latest fetched planets
                            self.listPeople.append(contentsOf: response.results)
                            self.delegate?.fetchDidSucceed()
                        }
                    }
                }
            }else {
                // Perform on main thread to update UI
                DispatchQueue.main.async { [self] in
                    // Internet is not working 
                    self.delegate?.fetchDidFail(with: NetworkError.internet.reason)
                }
                
            }
        }
    }
    
    func fetchFilm(with url: URL) {
        apiClient.fetch(with: url, page: nil, dataType: Resident.self) { result in
            switch result {
            case .failure(let error):
                // Perform on main thread to update UI
                DispatchQueue.main.async {
                    self.delegate?.fetchDidFail(with: error.reason)
                }
            case .success(let film):
                // Perform on main thread to update UI
                DispatchQueue.main.async {
                    self.residents.append(film)
                    self.delegate?.fetchDidSucceed()
                }
            }
        }
    }
}
