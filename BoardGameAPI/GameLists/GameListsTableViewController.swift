//
//  GameListsTableViewController.swift
//  BoardGameAPI
//
//  Created by Shien on 2022/6/2.
//

import UIKit

class GameListsTableViewController: UITableViewController {
    private let reuseIdentifier = "\(GameListsTableViewCell.self)"
    let decoder = JSONDecoder()
    var lists: [List]?
    var selectedRow = 0
    var loadingView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLists(url: URL(string: "https://api.boardgameatlas.com/api/lists?username=trentellingsen&pretty=true&client_id=JLBr5npPhV")!)
    }
    
    func showAlert() {
        loadingView.removeFromSuperview()
        let controller = UIAlertController(title: "error:", message: "Please check your Internet", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
            self.getLists(url: URL(string: "https://api.boardgameatlas.com/api/lists?username=trentellingsen&pretty=true&client_id=JLBr5npPhV")!)
        }))
        present(controller, animated: true)
    }
    
    func showActivityIndicator() {
        loadingView = UIActivityIndicatorView(frame: CGRect(x: 0, y: -50, width: view.bounds.width, height: view.bounds.height))
        loadingView.color = .white
        loadingView.startAnimating()
        view.addSubview(loadingView)
    }
    
    func getLists(url: URL) {
        showActivityIndicator()
        URLSession.shared.dataTask(with: url) { data, response, error in
            let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
                self.showAlert()
            }
            if let data = data {
                let gameLists = try? self.decoder.decode(GameLists.self, from: data)
                self.lists = gameLists?.lists
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.loadingView.removeFromSuperview()
                    timer.invalidate()
                    print("timer stop")
                }
            }
        }.resume()
    }
    
    @IBSegueAction func showWeb(_ coder: NSCoder) -> ViewController? {
        let controller = ViewController(coder: coder)
        controller?.webUrl = URL(string: lists![selectedRow].url)!
        return controller
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lists?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? GameListsTableViewCell else {
            return GameListsTableViewCell()
        }
        
        if let lists = lists {
            cell.gameImageView.image = try? UIImage(data: Data(contentsOf: lists[indexPath.row].images.medium))
            cell.nameLabel.text = lists[indexPath.row].name
            cell.gameCountsLabel.text = "\(lists[indexPath.row].gameCount) games"
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
