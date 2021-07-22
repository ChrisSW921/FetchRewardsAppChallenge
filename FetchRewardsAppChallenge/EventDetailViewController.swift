//
//  EventDetailViewController.swift
//  FetchRewardsAppChallenge
//
//  Created by Chris Withers on 7/20/21.
//

import UIKit
import WebKit
import SafariServices

class EventDetailViewController: UIViewController {
    
    var gradientView: GradientView = {
        return GradientView(color1: UIColor(named: "Navy"), color2: .lightGray)
    }()
    
    var scrollView: UIScrollView = {
        return UIScrollView()
    }()
    
    var contentView: UIView = {
        return UIView()
    }()
    
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
    
    var webView: WKWebView!
    
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
        setHeartImage()
    }
    
    @objc func getTicketsTapped() {
        guard let event = event else { return }
        let url = URL(string: event.venue.url)!
        let ticketVC = SFSafariViewController(url: url)
        ticketVC.modalPresentationStyle = .popover
        present(ticketVC, animated: true)
    }
    
    @objc func heartButtonTapped() {
        guard let event = event else { return }
        
        if EventController.shared.isFavorited(id: String(event.id)) {
            EventController.shared.removeFavorite(id: String(event.id))
        } else {
            EventController.shared.addFavorite(id: String(event.id))
        }
        setHeartImage()
    }
    
    func setHeartImage() {
        
        guard let event = event else { return }
        
        favoriteButton.setImage(EventController.shared.isFavorited(id: String(event.id)) ? UIImage(named: "heart") : UIImage(named: "heartOutline"), for: .normal)
    }
    
    func setUpConstraints() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(gradientView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        getTicketsButton.setTitle(" Get tickets ", for: .normal)
        getTicketsButton.setTitleColor(.white, for: .normal)
        getTicketsButton.layer.cornerRadius = 8
        getTicketsButton.backgroundColor = .darkGray
        getTicketsButton.clipsToBounds = true
        getTicketsButton.addTarget(self, action: #selector(getTicketsTapped), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        
        actionsStackView.axis = .horizontal
        actionsStackView.distribution = .equalSpacing
        actionsStackView.spacing = 15
        
        eventImageView.layer.cornerRadius = 10
        eventImageView.clipsToBounds = true
        
        titleLabel.font = .boldSystemFont(ofSize: 28)
        
        let secondaryFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        [locationLabel, dateLabel].forEach({
                        $0.font = secondaryFont
                        $0.textColor = .lightGray
        })
        
        [getTicketsButton,favoriteButton].forEach({actionsStackView.addArrangedSubview($0)})
        
        [titleLabel, eventImageView, locationLabel, dateLabel, actionsStackView].forEach({overallStackView.addArrangedSubview($0)})
        
        [titleLabel, locationLabel, dateLabel].forEach({
                        $0.numberOfLines = 0
                        $0.textAlignment = .center
        })
        
        contentView.addSubview(overallStackView)
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        overallStackView.axis = .vertical
        overallStackView.distribution = .equalSpacing
        overallStackView.alignment = .center
        overallStackView.spacing = 20
        
        
        NSLayoutConstraint.activate([
            
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            favoriteButton.heightAnchor.constraint(equalToConstant: 50),
            favoriteButton.widthAnchor.constraint(equalTo: favoriteButton.heightAnchor),
            
            eventImageView.heightAnchor.constraint(equalToConstant: 200),
            eventImageView.widthAnchor.constraint(equalTo: eventImageView.heightAnchor),
            
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            overallStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            overallStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            overallStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            overallStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            
            
            overallStackView.heightAnchor.constraint(equalToConstant: 600)
            
        ])
    }
}



