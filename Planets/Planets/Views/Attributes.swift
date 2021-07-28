//
//  Attributes.swift
//  Planets
//
//  Created by Mithlesh (InsanelyDeepak) on 28/07/21.
//  Copyright © 2021 Mithlesh Kumar. All rights reserved.
//

import Foundation

enum Attributes: Int, CaseIterable {
    case rotation_period, orbital_period, diameter, gravity, terrain, surface_water, population,residents  
        
    var title: String {
        switch self {
        case .rotation_period: return "Rotation Period"
        case .orbital_period: return "Orbital Period"
        case .diameter: return "Diameter"
        case .gravity: return "Gravity"
        case .terrain: return "Terrain"
        case .surface_water: return "Surface Water"
        case .population: return "Population"
        case .residents: return "Residents"            
        }
    }
    
    static func getCount() -> Int {
        return self.allCases.count
    }

    static func getSection(_ section: Int) -> Attributes {
        return self.allCases[section]
    }
}
