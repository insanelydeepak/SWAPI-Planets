//
//  LoadingView.swift
//  Planets
//
//  Created by Mithlesh (InsanelyDeepak) on 28/07/21.
//  Copyright © 2021 Mithlesh Kumar. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    
    var blurEffectView: UIVisualEffectView?
    
    // Initializer
    override init(frame: CGRect) {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView = blurEffectView
        
        blurEffectView.alpha = 0.9
        super.init(frame: frame)
        insertSubview(blurEffectView, at: 0)
        addLoader()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Label to show text
    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray
        label.text = "Loading..."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    // add on screen
    func addLoader() {
        let dimmensions: Int = 50
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: dimmensions, height: dimmensions)
    
        addSubview(activityIndicator)
        activityIndicator.center = center
        
        label.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 25)
        addSubview(label)
        label.center = CGPoint(x: center.x, y: activityIndicator.frame.origin.y + activityIndicator.frame.size.height + 5)
        activityIndicator.startAnimating()
    }
}

extension UIView {
    // to access easily
    func showLoader() {
        let loader = LoadingView(frame: frame)
        self.addSubview(loader)
    }
    
    func removeLoader() {
        if let loader = subviews.first(where: { $0 is LoadingView }) {
            loader.removeFromSuperview()
        }
    }
}

