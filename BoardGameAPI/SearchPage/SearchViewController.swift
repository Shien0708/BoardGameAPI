//
//  SearchViewController.swift
//  BoardGameAPI
//
//  Created by Shien on 2022/6/3.
//

import UIKit

class SearchViewController: UIViewController {
    var games = [Game]()
    var selectedItem = 0
    var buttons = [UIButton]()
    lazy var filteredGames = games
    
    @IBOutlet weak var searchLoadingView: UIActivityIndicatorView!
    @IBOutlet weak var gamesCollectionView: UICollectionView!
    @IBOutlet weak var searchTableView: UITableView!
    var searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        adjustSearchBar()
        fetchGames { result in
            switch result {
            case .success(let search):
                self.games = search.games
                DispatchQueue.main.async {
                    self.searchLoadingView.isHidden = true
                    self.searchTableView.reloadData()
                    self.gamesCollectionView.reloadData()
                }
                print("fetch games success")
            case .failure(let networkError):
                switch networkError {
                case .requestFailed(let error):
                    print(networkError, error)
                case .invalidUrl:
                    print(networkError)
                case .invalidData:
                    print(networkError)
                case .invalidResponse:
                    print(networkError)
                }
            }
        }
        resizeCell()
    }
    
    func resizeCell(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: (view.bounds.width-10)/2, height: (view.bounds.width-10)/2)
        gamesCollectionView.collectionViewLayout = layout as UICollectionViewLayout
    }

    func adjustSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.tintColor = .white
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.automaticallyShowsCancelButton = true
    }
    
    func showAlert(){
        searchLoadingView.isHidden = true
        let controller = UIAlertController(title: "error:", message: "please check you internet", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
            self.searchLoadingView.isHidden = false
            self.fetchGames { result in
                switch result {
                case .success(let search):
                    self.games = search.games
                    DispatchQueue.main.async {
                        self.searchLoadingView.isHidden = true
                        self.searchTableView.reloadData()
                        self.gamesCollectionView.reloadData()
                    }
                case .failure(let networkError):
                    switch networkError {
                    case .requestFailed(let error):
                        print(networkError, error)
                    case .invalidUrl:
                        print(networkError)
                    case .invalidData:
                        print(networkError)
                    case .invalidResponse:
                        print(networkError)
                    }
                }
            }
        }))
        present(controller, animated: true)
    }
    
    enum NetworkError: Error {
        case invalidUrl
        case requestFailed(Error)
        case invalidData
        case invalidResponse
    }
    
    func fetchGames(completion: @escaping(Result<Search, NetworkError>)->Void) {
        guard let url = URL(string: "https://api.boardgameatlas.com/api/search?name=Catan&pretty=true&client_id=JLBr5npPhV") else { return completion(.failure(.invalidUrl)) }
            let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                self.showAlert()
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                       return  completion(.failure(.invalidResponse))
                    }
                    let decoder = JSONDecoder()
                    do {
                        let results = try decoder.decode(Search.self, from: data)
                        completion(.success(results))
                        timer.invalidate()
                    }
                    catch {
                        completion(.failure(.requestFailed(error)))
                    }
                } else {
                    completion(.failure(.invalidData))
            }
        }.resume()
    }
    
    @IBSegueAction func showGameInfo(_ coder: NSCoder) -> GameInfoTableViewController? {
        var index = 0
        while !buttons[index].isTouchInside {
            index += 1
        }
        selectedItem = Int((buttons[index].titleLabel?.text!)!)!
        let controller = GameInfoTableViewController(coder: coder)
        controller?.game = games[selectedItem]
        return controller
    }
    

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let gameNames = filteredGames[indexPath.row]
        content.text = gameNames.name
        cell.contentConfiguration = content
        
        return cell
    }
}


extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.isEmpty == false {
            filteredGames = games.filter({ game in
                game.name.contains(text.lowercased())
            })
        } else {
            filteredGames = games
        }
        searchTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchTableView.isHidden = false
        view.bringSubviewToFront(searchTableView)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchTableView.isHidden = true
        print("cancel button clicked")
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GameCollectionViewCell
        
        cell.nameLabel.text = games[indexPath.item].name
        cell.gameImageView.image = try? UIImage(data: Data(contentsOf: games[indexPath.item].image_url))
        cell.gameButton.setTitle("\(indexPath.item)", for: .normal)
        if !buttons.contains(cell.gameButton) {
            buttons.append(cell.gameButton)
        }
        
        return cell
    }
}

