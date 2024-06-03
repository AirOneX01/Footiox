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
    
    var teamList = [TeamModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TeamCell.nib, forCellReuseIdentifier: TeamCell.reuseId)

        setData()
        // Do any additional setup after loading the view.
    }
    
    private func setData(){
        if let league = selectedLeague{
            leagueName.text = league.name
            if let imageURL = URL(string: league.image){
                leagueImage.loadImageFromURL(imageURL)
            }
            leagueDates.text = league.dates
            ApiManager.loadParticipants(league: league) { teams in
                DispatchQueue.main.async {
                    self.teamList.removeAll()
                    self.teamList.append(contentsOf: teams)
                    self.tableView.reloadData()
                }
            }
        }
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
        return teamList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeamCell.reuseId, for: indexPath) as! TeamCell
        
        if let imageURL = URL(string: teamList[indexPath.row].logo){
            cell.teamImage.loadImageFromURL(imageURL)
        }
        cell.teamName.text = teamList[indexPath.row].name
        
        if teamList[indexPath.row].year.isEmpty {
            cell.teamYear.text = "N/A"
        }else{
            cell.teamYear.text = teamList[indexPath.row].year
        }
        
        return cell
    }
    
    
}
