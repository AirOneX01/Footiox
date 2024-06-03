//
//  HeaderCell.swift
//  My Score
//
//  Created by admin on 16.04.2024.
//

import UIKit

class HeaderCell: UITableViewCell {
    
    static let reuseId = String(describing: HeaderCell.self)
    static let nib = UINib(nibName: String(describing: HeaderCell.self), bundle: nil)
    
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var leagueSeason: UILabel!
    @IBOutlet weak var leagueImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

