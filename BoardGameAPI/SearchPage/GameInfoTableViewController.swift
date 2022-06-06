//
//  GameInfoTableViewController.swift
//  BoardGameAPI
//
//  Created by Shien on 2022/6/4.
//

import UIKit

class GameInfoTableViewController: UITableViewController {

    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet var priceLabels: [UILabel]!
    @IBOutlet weak var minPlayerLabel: UILabel!
    @IBOutlet weak var designerLabel: UILabel!
    @IBOutlet weak var maxTimeLabel: UILabel!
    @IBOutlet weak var minTimeLabel: UILabel!
    @IBOutlet weak var maxPlayerLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var officialUrlTextView: UITextView!
    var game: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // MARK: - Table view data source
    func updateUI() {
        if let game = game {
            gameNameLabel.text = game.name
            gameImageView.image = try? UIImage(data: Data(contentsOf: game.image_url))
            descriptionTextView.text = game.description
            priceLabels[0].text = game.price_ca
            priceLabels[1].text = game.price_uk
            priceLabels[2].text = game.price_au
            discountLabel.text = "\(game.discount)"
            maxPlayerLabel.text = "\(game.max_players)"
            minPlayerLabel.text = "\(game.min_players)"
            maxTimeLabel.text = "\(game.max_playtime) min"
            minTimeLabel.text = "\(game.min_playtime) min"
            if let url = game.official_url {
                officialUrlTextView.text = "\(url)"
            } else {
                officialUrlTextView.text = ""
            }
            
            designerLabel.text = game.primary_designer?.name ?? ""
            
        }
    }
  

}
