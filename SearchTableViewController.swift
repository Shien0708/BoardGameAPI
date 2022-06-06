//
//  SearchTableViewController.swift
//  BoardGameAPI
//
//  Created by Shien on 2022/6/3.
//

import UIKit

class SearchTableViewController: UITableViewController {
    var resultController: ResultsTableViewController!
    
    let movies = ["蜘蛛人1","蜘蛛人二","蜘蛛人三","四","五","六","7","8","9","10","11","12"]

    override func viewDidLoad() {
        super.viewDidLoad()
        resultController = storyboard?.instantiateViewController(withIdentifier: "\(ResultsTableViewController.self)") as? ResultsTableViewController
        let searchController = UISearchController(searchResultsController: resultController)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsCancelButton = true
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = movies[indexPath.row]

        return cell
    }
    
}

extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchText.isEmpty == false {
            resultController.filteredMovies = movies.filter({ movie in
                movie.localizedStandardContains(searchText)
            })
        } else {
            resultController.filteredMovies = []
        }
            resultController.tableView.reloadData()
    }
}
