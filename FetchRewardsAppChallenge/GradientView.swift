//
//  GradientView.swift
//  FetchRewardsAppChallenge
//
//  Created by Chris Withers on 7/21/21.
//

import UIKit

class GradientView: UIView {

    let gradientLayer = CAGradientLayer()
    
    init(color1: UIColor?, color2: UIColor?) {
        super.init(frame: .zero)
        
        guard let color1 = color1, let color2 = color2 else { return }
        
        let cg1 = color1.cgColor
        let cg2 = color2.cgColor
        
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [cg1, cg2]
        gradientLayer.locations = [0.0, 1.0]
        self.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.bounds
    }
}
