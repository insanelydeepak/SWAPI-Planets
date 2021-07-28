//
//  UtilityFunctions.swift
//  Planets
//
//  Created by Mithlesh (InsanelyDeepak) on 28/07/21.
//  Copyright © 2021 Mithlesh Kumar. All rights reserved.
//

import UIKit
import SystemConfiguration

class UtilityHelper {
    
    // Check internet is available or not
    class func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    
    // MARK: -
    // MARK: Session Save
    // MARK: -
    
    class func saveSessionToDisk(_ Session: Data) {
        let fullPath = getDocumentsDirectory().appendingPathComponent(SavedSession.planets.rawValue)
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: Session, requiringSecureCoding: false)
            try data.write(to: fullPath)            
        } catch {
            print("saveSessionToDisk :: failed")
        }
    }
    
    class func loadSessionFromDisk() -> Data? {
        let fullPath = getDocumentsDirectory().appendingPathComponent(SavedSession.planets.rawValue)
        if let nsData = NSData(contentsOf: fullPath) {
            do {
                let data = Data(referencing:nsData)
                if let loadedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Data {
                    return loadedData
                }
            } catch {
                print("Couldn't read file.")
                return nil
            }
        }       
        return nil
    }
    
}
