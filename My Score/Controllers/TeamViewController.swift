//
//  TeamViewController.swift
//  My Score
//
//  Created by Air One on 6/26/24.
//

import UIKit

class TeamViewController: UIViewController {
    
    var teamID: Int!
    
    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamCode: UILabel!
    @IBOutlet weak var teamCountry: UILabel!
    @IBOutlet weak var teamYear: UILabel!
    @IBOutlet weak var teamNational: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamName.text = "Loading..."

        ApiManager.loadTeams(id: teamID) { it in
            if it != nil {
                DispatchQueue.main.async {
                    self.setValues(team: it!)
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    private func setValues(team: TeamModel){
        
        teamName.text = team.name
        teamCode.text = team.code
        teamCountry.text = team.country
        teamYear.text = team.year
        if team.national {
            teamNational.text = "Yes"
        }else{
            teamNational.text = "No"
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
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
