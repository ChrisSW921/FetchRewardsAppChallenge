//
//  EventTableViewCell.swift
//  FetchRewardsAppChallenge
//
//  Created by Chris Withers on 7/19/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    var heartImageView: UIImageView = {
        return UIImageView()
    }()
    
    var titleLabel: UILabel = {
        return UILabel()
    }()
    
    var locationLabel: UILabel = {
        return UILabel()
    }()
    
    var timeLabel: UILabel = {
        return UILabel()
    }()
    
    var eventImageView: UIImageView = {
        return UIImageView()
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with event: Event) {
        titleLabel.text = event.title
        locationLabel.text = "\(event.venue.address)\n\(event.venue.city)\n\(event.venue.state)"
        timeLabel.text = event.datetime_local.convertToDate()
        EventController.shared.fetchImageForEvent(event: event) { (result) in
            switch result {
            
            case .success(let image):
                DispatchQueue.main.async {
                    self.eventImageView.image = image
                }
            case .failure(_):
                print("No image found")
            }
        }
        heartImageView.rotate()
    }
    
    func setUpConstraints() {
        
        [eventImageView, heartImageView, titleLabel, locationLabel, timeLabel].forEach({
                contentView.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            })
        
        heartImageView.image = UIImage(named: "heart")
        
        eventImageView.layer.cornerRadius = 10
        eventImageView.clipsToBounds = true
        
        [titleLabel, locationLabel, timeLabel].forEach({
                $0.lineBreakMode = .byWordWrapping
                $0.numberOfLines = 0
        })
        
        titleLabel.font = .boldSystemFont(ofSize: 28)
        
        let secondaryFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        [locationLabel, timeLabel].forEach({
                        $0.font = secondaryFont
                        $0.textColor = .lightGray
        })
        
        let padding: CGFloat = 25
        
        NSLayoutConstraint.activate([
            eventImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            eventImageView.heightAnchor.constraint(equalToConstant: 100),
            eventImageView.widthAnchor.constraint(equalTo: eventImageView.heightAnchor),
            
            heartImageView.centerXAnchor.constraint(equalTo: eventImageView.leadingAnchor),
            heartImageView.centerYAnchor.constraint(equalTo: eventImageView.topAnchor),
            heartImageView.heightAnchor.constraint(equalToConstant: 25),
            heartImageView.widthAnchor.constraint(equalToConstant: 25),
            
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            locationLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: padding),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            timeLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: padding),
            timeLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: padding),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
            
            
        ])
    }
}

extension UIView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
