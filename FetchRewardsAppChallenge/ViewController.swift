//
//  ViewController.swift
//  FetchRewardsAppChallenge
//
//  Created by Chris Withers on 7/19/21.
//

import UIKit

class ViewController: UIViewController {
    
    var searchBar: UISearchBar = {
       return UISearchBar()
    }()
    
    var tableView: UITableView = {
        return UITableView()
    }()
    
    var emptyStateView: EmptyStateView = {
        return EmptyStateView(frame: .zero)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor(named: "Navy")
        view.backgroundColor = UIColor(named: "Navy")
        EventController.shared.fetchAllFavorites()
        addAndConfigureSearchBar()
        addAndConfigureTableView()
        configureEmptyStateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        self.title = "All Events"
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func configureEmptyStateView() {
        self.view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    func addAndConfigureSearchBar() {
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.showsCancelButton = true
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            
            if #available(iOS 13, *) {
                textfield.textColor = .white
            } else {
                textfield.textColor = .black
            }
            
            
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .lightGray
            
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = .white                }
        }
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        searchBar.barTintColor = UIColor(named: "Navy")
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func addAndConfigureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "EventCell")
        tableView.estimatedRowHeight = 300
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventController.shared.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as? EventTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: EventController.shared.events[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let event = EventController.shared.events[indexPath.row]
        
        guard let cell = tableView.cellForRow(at: indexPath) as? EventTableViewCell else { return }
        
        let detailView = EventDetailViewController()
        detailView.event = event
        detailView.eventImage = cell.eventImageView.image
        navigationController?.pushViewController(detailView, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            EventController.shared.events = []
            DispatchQueue.main.async {
                //Show the empty state
                self.emptyStateView.isHidden = false
                self.tableView.reloadData()
            }
        } else {
            EventController.shared.fetchEventsForSearchString(searchString: searchText) { (result) in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.emptyStateView.isHidden = true
                        self.tableView.reloadData()
                    }
                case .failure(_):
                    print("Failure")
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        EventController.shared.events = []
        DispatchQueue.main.async {
            //Show the empty state
            self.emptyStateView.isHidden = false
            self.tableView.reloadData()
        }
        searchBar.resignFirstResponder()
    }
}

