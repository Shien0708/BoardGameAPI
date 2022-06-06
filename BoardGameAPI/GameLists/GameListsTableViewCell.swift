//
//  GameListsTableViewCell.swift
//  BoardGameAPI
//
//  Created by Shien on 2022/6/2.
//

import UIKit

class GameListsTableViewCell: UITableViewCell {

    @IBOutlet weak var gameCountsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
