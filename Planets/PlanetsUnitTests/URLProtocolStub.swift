//
//  URLProtocolStub.swift
//  PlanetsUnitTests
//
//  Created by Mithlesh (InsanelyDeepak) on 28/07/21.
//  Copyright © 2021 Mithlesh Kumar. All rights reserved.
//

import Foundation

/*
 Create custom subclass of URLProtocol to handle network requests
 Resources pulled from this Hacking With Swift post:
 https://www.hackingwithswift.com/articles/153/how-to-test-ios-networking-code-the-easy-way
 ...this Ray Wenderlich post:
 https://www.raywenderlich.com/960290-ios-unit-testing-and-ui-testing-tutorial
 ...this Medium post:
 https://medium.com/@dhawaldawar/how-to-mock-urlsession-using-urlprotocol-8b74f389a67a
 and this Augmented Code post:
 https://augmentedcode.io/2019/05/26/testing-networking-code-with-custom-urlprotocol-on-ios/
 */

// Stub: Returns fixed data
final class URLProtocolStub: URLProtocol {
    
    // Dictionary that stores the data we expect from different URLs
    static var testURLs = [URL?: Data]()
    
    override class func canInit(with request: URLRequest) -> Bool {
        // Returning true means we will handle all url requests
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    // Request Handler to test the request and return mock response
    static var requestHandler: ((URLRequest) -> (Data?, HTTPURLResponse, Error?))?
    
    override func startLoading() {
        guard let handler = URLProtocolStub.requestHandler else {
            fatalError("Request Handler is unavailable")
        }
        let (data, response, error) = handler(request)
        if let safeData = data {
            // Return test data immediately
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: safeData)
            client?.urlProtocolDidFinishLoading(self)
        } else if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // Leave empty as this protocol is not asynchronous
    }
}
