//
//  TeamCell.swift
//  My Score
//
//  Created by admin on 25.04.2024.
//

import UIKit

class TeamCell: UITableViewCell {
    
    static let reuseId = String(describing: TeamCell.self)
    static let nib = UINib(nibName: String(describing: TeamCell.self), bundle: nil)

    @IBOutlet weak var teamName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
