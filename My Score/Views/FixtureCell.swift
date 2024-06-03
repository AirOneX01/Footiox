//
//  FixtureCell.swift
//  My Score
//
//  Created by admin on 16.04.2024.
//

import UIKit

class FixtureCell: UITableViewCell {
    
    static let reuseId = String(describing: FixtureCell.self)
    static let nib = UINib(nibName: String(describing: FixtureCell.self), bundle: nil)
    
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var homeName: UILabel!
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var awayImage: UIImageView!
    @IBOutlet weak var awayName: UILabel!
    @IBOutlet weak var awayScore: UILabel!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var playedStar: UIImageView!
    @IBOutlet weak var dateText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
