//
//  LeagueDetailViewController.swift
//  My Score
//
//  Created by admin on 16.04.2024.
//

import UIKit

class LeagueDetailViewController: UIViewController {
    
    
    var selectedLeague: LeagueModel? = nil
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var leagueImage: UIImageView!
    @IBOutlet weak var leagueDates: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var newsList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TeamCell.nib, forCellReuseIdentifier: TeamCell.reuseId)
        
        if let league = selectedLeague {
            leagueName.text = league.name
            leagueDates.text = league.dates
            
            if let url = URL(string: league.image){
                leagueImage.loadImageFromURL(url)
            }
        }

        newsList.removeAll()
        newsList.append(contentsOf: FirebaseManager.news)
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func backPressed(_ sender: UIButton) {
            dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension LeagueDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeamCell.reuseId, for: indexPath) as! TeamCell
        
        cell.teamName.text = newsList[indexPath.row]
        
        
        return cell
    }
    
    
}
