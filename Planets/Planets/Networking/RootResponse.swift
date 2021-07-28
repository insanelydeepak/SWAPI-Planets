//
//  PagedResponse.swift
//  Planets
//
//  Created by Mithlesh (InsanelyDeepak) on 27/07/21.
//  Copyright © 2021 Mithlesh Kumar. All rights reserved.
//

import Foundation

struct RootResponse: Codable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [Planet]
}
