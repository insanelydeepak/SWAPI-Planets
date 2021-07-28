//
//  NetworkError.swift
//  Planets
//
//  Created by Mithlesh (InsanelyDeepak) on 27/07/21.
//  Copyright © 2021 Mithlesh Kumar. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case request
    case decoding
    case network
    case internet
    case unknown

    var reason: String {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .request:
            return "Error occurred while fetching data"
        case .decoding:
            return "Error occurred while decoding data"
        case .network:
            return "Unsuccessful HTTP response"
        case .internet:
            return "connection appears to be offline"
        case .unknown:
            return "Network Error"
        }
    }
}
