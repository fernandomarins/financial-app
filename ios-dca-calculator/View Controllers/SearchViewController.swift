//
//  SearchViewController.swift
//  ios-dca-calculator
//
//  Created by Fernando Marins on 24/12/21.
//

import UIKit
import Combine

class SearchViewController: UITableViewController {
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Enter a company name or symbol"
        sc.searchBar.autocapitalizationType = .allCharacters
        return sc
    }()
    
    private let apiService = APIService()
    // we need to create a subscribers when using combine
    private var subscribers = Set<AnyCancellable>()
    private var searchResults: SearchResults?
    // the published keyword is used to make the object observable
    @Published private var searchQuery = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        observableForm()
    }

    private func setupNavigationBar() {
        navigationItem.searchController = searchController
    }
    
    private func observableForm() {
        $searchQuery.debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] searchQuery in
            
            self.apiService.fetchSymbolsPublisher(keywords: searchQuery).sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    break
                }
            } receiveValue: { searchResults in
                self.searchResults = searchResults
                self.tableView.reloadData()
            }.store(in: &self.subscribers)
            
        }.store(in: &subscribers)
        
        

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! SearchTableViewCell
        
        if let searchResults = self.searchResults {
            let searchResult = searchResults.items
            cell.configure(with: searchResult[indexPath.row])
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.items.count ?? 0
    }

}

extension SearchViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else {
            return
        }
        
        self.searchQuery = searchQuery
        
    }
    
    
}
