//
//  Constants.swift
//  Planets
//
//  Created by Mithlesh (InsanelyDeepak) on 27/07/21.
//  Copyright © 2021 Mithlesh Kumar. All rights reserved.
//

import Foundation
import UIKit


let APP_DELEGATE:AppDelegate = ((UIApplication.shared.delegate as! AppDelegate))
let USER_DEFAULTS = UserDefaults.standard
let APPLICATION = UIApplication.shared
let NOTIFICATION_CENTER = NotificationCenter.default

let MAIN_BUNDLE = Bundle.main
let MAIN_THREAD = Thread.main
let MAIN_SCREEN = UIScreen.main
let CURRENT_DEVICE = UIDevice.current
let MAIN_RUN_LOOP = RunLoop.main

// Device screen specifications / interface idiom
let IS_IPAD = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
let IS_IPHONE = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone


enum SavedSession: String {
    case planets            = "planet_session"
}

struct AlertKey {
    static let SUCCESS     = "Success!"
    static let FAILURE     = "Failure!"
    static let ERROR       = "Error!"
    static let INFO        = "Info!"
    static let ATTENTION   = "Attention!"
    static let WARNING     = "Warning!"
    static let QUESTION    = "Question?"
    static let OPTIONS     = "Options!"
    static let REQUIREMENT = "Requirement!";
}
