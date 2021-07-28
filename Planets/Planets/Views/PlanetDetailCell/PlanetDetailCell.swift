//
//  PlanetDetailCell.swift
//  Planets
//
//  Created by Mithlesh (InsanelyDeepak) on 28/07/21.
//  Copyright © 2021 Mithlesh Kumar. All rights reserved.
//

import UIKit

class PlanetDetailCell: UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView! {
        didSet {
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    // MARK: - Variables and Properties
    
    func configureCell(with text: String) {
        infoLabel?.text = text
    }

}
