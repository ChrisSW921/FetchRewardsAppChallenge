//
//  EventDetailViewController.swift
//  FetchRewardsAppChallenge
//
//  Created by Chris Withers on 7/20/21.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    var overallStackView: UIStackView = {
        return UIStackView()
    }()
    
    var titleLabel: UILabel = {
        return UILabel()
    }()
    
    var eventImageView: UIImageView = {
        return UIImageView()
    }()
    
    var locationLabel: UILabel = {
        return UILabel()
    }()
    
    var dateLabel: UILabel = {
        return UILabel()
    }()
    
    var actionsStackView: UIStackView = {
        return UIStackView()
    }()
    
    var favoriteButton: UIButton = {
        return UIButton()
    }()
    
    var getTicketsButton: UIButton = {
        return UIButton()
    }()
    
    var event: Event? {
        didSet {
            guard let event = event else { return }
            titleLabel.text = event.title
            locationLabel.text = "\(event.venue.address)\n\(event.venue.city)\n\(event.venue.state)"
            dateLabel.text = event.datetime_local.convertToDate()
        }
    }
    
    var eventImage: UIImage? {
        didSet{
            eventImageView.image = eventImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpConstraints()
    }
    
    func setUpConstraints() {
        
        getTicketsButton.setTitle(" Get tickets ", for: .normal)
        getTicketsButton.setTitleColor(.black, for: .normal)
        getTicketsButton.layer.cornerRadius = 8
        getTicketsButton.backgroundColor = .lightGray
        getTicketsButton.clipsToBounds = true
        favoriteButton.setImage(UIImage(named: "heartOutline"), for: .normal)
        
        actionsStackView.axis = .horizontal
        actionsStackView.distribution = .equalSpacing
        actionsStackView.spacing = 15
        
        [getTicketsButton,favoriteButton].forEach({actionsStackView.addArrangedSubview($0)})
        
        [titleLabel, eventImageView, locationLabel, dateLabel, actionsStackView].forEach({overallStackView.addArrangedSubview($0)})
        
        [titleLabel, locationLabel, dateLabel].forEach({
                        $0.numberOfLines = 0
                        $0.textAlignment = .center
        })
        
        view.addSubview(overallStackView)
        
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        overallStackView.axis = .vertical
        overallStackView.distribution = .equalSpacing
        overallStackView.alignment = .center
        overallStackView.spacing = 20
        
        
        NSLayoutConstraint.activate([
            
            favoriteButton.heightAnchor.constraint(equalToConstant: 50),
            favoriteButton.widthAnchor.constraint(equalTo: favoriteButton.heightAnchor),
            
            eventImageView.heightAnchor.constraint(equalToConstant: 200),
            eventImageView.widthAnchor.constraint(equalTo: eventImageView.heightAnchor),
            
            overallStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            overallStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            overallStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
    }
    

}
