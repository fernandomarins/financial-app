//
//  SearchViewController.swift
//  ios-dca-calculator
//
//  Created by Fernando Marins on 24/12/21.
//

import UIKit
import Combine
import MBProgressHUD

class SearchViewController: UITableViewController, UIAnimatable {
    
    private enum Mode {
        case onboarding
        case search
    }
    
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
    @Published private var mode: Mode = .onboarding
    // the published keyword is used to make the object observable
    @Published private var searchQuery = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        observableForm()
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.title = "Search"
    }
    
    private func setupTableView() {
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
    }
    
    private func observableForm() {
        $searchQuery.debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] searchQuery in
                
                // to avoid showing the activity view when the app runs
                guard !searchQuery.isEmpty else { return }
                
                showLoadingAnimation()
                
                self.apiService.fetchSymbolsPublisher(keywords: searchQuery).sink { completion in
                    
                    hideLoadingAnimation()
                    
                    switch completion {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished:
                        break
                    }
                } receiveValue: { searchResults in
                    self.searchResults = searchResults
                    self.tableView.reloadData()
                    self.tableView.isScrollEnabled = true
                }.store(in: &self.subscribers)
                
            }.store(in: &subscribers)
        
        $mode.sink { [unowned self] mode in
            switch mode {
            case .onboarding:
                self.tableView.backgroundView = SearchPlaceholderView()
            case .search:
                self.tableView.backgroundView = nil
            }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let searchResults = searchResults {
            let symbol = searchResults.items[indexPath.row].symbol
            let searchResult = searchResults.items[indexPath.row]
            handleSelection(for: symbol, searchResult: searchResult)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.items.count ?? 0
    }
    
    private func handleSelection(for symbol: String, searchResult: SearchResult) {
        showLoadingAnimation()
        
        apiService.fetchTimesSeriesMonthlyAdjusted(keywords: symbol).sink { [weak self] completion in
            
            self?.hideLoadingAnimation()
            switch completion {
            case .failure(let error):
                debugPrint(error)
            case .finished:
                break
            }
        } receiveValue: { [weak self] timeSeriesMonthlyAdjusted in
            
            self?.hideLoadingAnimation()
            
            let asset = Asset(searchResult: searchResult, timeSeriesMonthlyAdjusted: timeSeriesMonthlyAdjusted)
            
            self?.performSegue(withIdentifier: "showCalculator", sender: asset)
            self?.searchController.searchBar.text = nil
        }.store(in: &subscribers)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCalculator",
        let destionation = segue.destination as? CalculatorTableViewController,
        let asset = sender as? Asset {
            destionation.asset = asset
        }
    }
    
}

extension SearchViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else {
            return
        }
        
        self.searchQuery = searchQuery
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        mode = .search
    }
    
}
