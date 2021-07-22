//
//  EmptyStateView.swift
//  FetchRewardsAppChallenge
//
//  Created by Chris Withers on 7/21/21.
//

import UIKit

class EmptyStateView: UIView {
    
    
    
    
    let gradientView = GradientView(color1: UIColor(named: "Navy"), color2: .white)
    let logoButton = UIButton(frame: .zero)
    let searchForResultsLabel = UILabel(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpconstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpconstraints() {
        addSubview(gradientView)
        addSubview(logoButton)
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        logoButton.translatesAutoresizingMaskIntoConstraints = false
        
        logoButton.setImage(UIImage(named: "Logo"), for: .normal)
        
        NSLayoutConstraint.activate([
            
            gradientView.topAnchor.constraint(equalTo: topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            
            logoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoButton.heightAnchor.constraint(equalToConstant: 100),
            logoButton.widthAnchor.constraint(equalTo: logoButton.heightAnchor)
        ])
    }
    
    
}
