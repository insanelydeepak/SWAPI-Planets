//
//  UIVViewController.swift
//  Planets
//
//  Created by Mithlesh (InsanelyDeepak) on 28/07/21.
//  Copyright © 2021 Mithlesh Kumar. All rights reserved.
//

import UIKit
extension UIViewController {
    // MARK:- UIAlertController

    typealias AlertViewDismissHandler = () -> Void
    typealias AlertViewCurrentPasswordConfirmedHandler = (String) -> Void

    func showAlertViewWithTitle(title:String,message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func showAlertViewWithTitle(title:String,message : String, dismissCompletion:@escaping (AlertViewDismissHandler))
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
             dismissCompletion()
            }))
        present(alertController, animated: true, completion:nil)
    }

    func showConfirmationAlertViewWithTitle(title:String,message : String, dismissCompletion:@escaping (AlertViewDismissHandler)){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "YES", style: .default, handler: { action -> Void in
            dismissCompletion()
        }))

        alertController.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { action -> Void in
        }))

        present(alertController, animated: true, completion:nil)
    }    

    
    
}

extension UIViewController {
    // MARK:- Show Loader
    func showLoader() {
        self.view.showLoader()
    }
    
    func removeLoader() {
        self.view.removeLoader()
    }
}
