//
//  LeagueCell.swift
//  My Score
//
//  Created by admin on 16.04.2024.
//

import UIKit

class LeagueCell: UITableViewCell {
    
    static let reuseId = String(describing: LeagueCell.self)
    static let nib = UINib(nibName: String(describing: LeagueCell.self), bundle: nil)

    @IBOutlet weak var legueName: UILabel!
    @IBOutlet weak var legueDates: UILabel!
    @IBOutlet weak var legueImage: UIImageView!
    @IBOutlet weak var selectImage: UIImageView!
    
    var selectedLeague: (()-> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func selectPressed(_ sender: UIButton) {
        selectedLeague?()
    }
    
    
}
