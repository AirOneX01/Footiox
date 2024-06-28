//
//  StatCell.swift
//  My Score
//
//  Created by Air One on 6/27/24.
//

import UIKit

class StatCell: UITableViewCell {
    
    static let reuseId = String(describing: StatCell.self)
    static let nib = UINib(nibName: String(describing: StatCell.self), bundle: nil)

    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var homeText: UILabel!
    @IBOutlet weak var awayText: UILabel!
    
    @IBOutlet weak var homeProgress: UIProgressView!
    @IBOutlet weak var awayProgress: UIProgressView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let radians = 180 * CGFloat.pi / 180
        homeProgress.transform = CGAffineTransform(rotationAngle: radians)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
