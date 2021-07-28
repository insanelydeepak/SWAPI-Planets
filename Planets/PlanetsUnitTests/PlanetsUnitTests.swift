//
//  PlanetsUnitTests.swift
//  PlanetsUnitTests
//
//  Created by Mithlesh (InsanelyDeepak) on 28/07/21.
//  Copyright © 2021 Mithlesh Kumar. All rights reserved.
//

import XCTest
@testable import Planets

class PlanetsUnitTests: XCTestCase {
    var planetsViewModel: PlanetsViewModel!
    let apiUrl = URL(string: "http://swapi.dev/api/planets/")!
    
    override func setUp() {
        super.setUp()
        planetsViewModel = PlanetsViewModel(delegate: self)
        
        // Inject URLSession configured with URLProtocolStub
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: config)
        planetsViewModel.apiClient = APIClient(session: session)
    }

    override func tearDown() {
        planetsViewModel = nil
        URLProtocolStub.requestHandler = nil
        super.tearDown()
    }
    
    func testFetchingDataSuccess() {
        // Decode mock JSON data from page 1 of results
        let jsonPath = Bundle(for: type(of: self)).path(forResource: "planetsTestData", ofType: "json")
        let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath!))
        
        // Call handler with a request and return mock response
        // In this example, we are only validating a URL
        URLProtocolStub.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (jsonData, response, nil)
        }
        
        // Call API
        let promise = expectation(description: "Success Response from Fetching Data")
        planetsViewModel.apiClient.fetch(with: nil, page: nil, dataType: RootResponse.self) { result in
            switch result {
            case .success(let payload):
                XCTAssertEqual(payload.count, 60)
                XCTAssertEqual(payload.next, URL(string: "https://swapi.dev/api/planets/?page=2"))
                XCTAssertEqual(payload.previous, nil)
                XCTAssertEqual(payload.results.count, 10)
            case .failure(let error):
                XCTFail("Unexpected Failure Reponse: \(error.reason)")
            }
            // When app receives a response, expectation is fulfilled
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testFetchingDataFailure() {
        // Use incorrect JSON data to check for decoding error
        let incorrectData = Data()

        URLProtocolStub.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (incorrectData, response, nil)
        }

        // Call API
        let promise = expectation(description: "Failure Response from Fetching Data")
        planetsViewModel.apiClient.fetch(with: nil, page: nil, dataType: RootResponse.self) { result in
            switch result {
            case .success(_):
                XCTFail("Unexpected Success Response")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.decoding)
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
}
// MARK: - PlanetsViewModelDelegate

extension PlanetsUnitTests: PlanetsViewModelDelegate {
    func fetchDidSucceed() { }
    func fetchDidFail(with description: String) {  }
    
}
