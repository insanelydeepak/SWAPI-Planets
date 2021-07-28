//
//  PlanetCell.swift
//  Planets
//
//  Created by Mithlesh (InsanelyDeepak) on 27/07/21.
//  Copyright © 2021 Mithlesh Kumar. All rights reserved.
//

import UIKit

class PlanetCell: UITableViewCell {

    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Customize cell when selected
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        selectedBackgroundView = backgroundView
    }
    
    // MARK: - Variables and Properties

    var planet: Planet! {
        didSet {
            textLabel?.text = planet.name
        }
    }
}
