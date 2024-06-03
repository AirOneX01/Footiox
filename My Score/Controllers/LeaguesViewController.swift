//
//  LeaguesViewController.swift
//  My Score
//
//  Created by admin on 16.04.2024.
//

import UIKit

class LeaguesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIStackView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var leagueList: [LeagueModel] = []
    var selectedList: [LeagueModel] = []
    var selectedLeague: LeagueModel? = nil
    var filteredLeagues: [LeagueModel] = []
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LeagueCell.nib, forCellReuseIdentifier: LeagueCell.reuseId)

        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        // Do any additional setup after loading the view.
        setList()
        getSelectedList()
    }
    
    private func getSelectedList(){
        selectedList.removeAll()
        selectedList.append(contentsOf: PListManager.loadSelectedLeaguesFromPlist())
    }
    
    private func setSelectedList(){
        PListManager.saveSelectedLeaguesToPlist(leagues: selectedList)
    }
    
    func showAlert() {
            let alertController = UIAlertController(title: "Oops...", message: "Some error occurred, do you want to try again?", preferredStyle: .alert)
            
            let tryAgainAction = UIAlertAction(title: "Try again", style: .default) { _ in
                self.setList()
            }
            alertController.addAction(tryAgainAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            }
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    
    private func setList(){
        loadingView.isHidden = false
        ApiManager.loadLeagues { leagues in
            
            DispatchQueue.main.async {
                if leagues != nil {
                    self.leagueList.removeAll()
                    self.leagueList.append(contentsOf: leagues ?? [])
                    self.tableView.reloadData()
                }else{
                    self.showAlert()
                }
                UIView.animate(withDuration: 1.0) {
                    self.loadingView.isHidden = true
                }
            }
        }
    }

    @IBAction func scoresPressed(_ sender: UIButton) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LeaguesToDetails"{
            var destination = segue.destination as! LeagueDetailViewController
            destination.selectedLeague = selectedLeague
        }
    }
    
    
    

}

extension LeaguesViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredLeagues.count
        }else{
            return leagueList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LeagueCell.reuseId, for: indexPath) as! LeagueCell
        
        var league: LeagueModel
        if isSearching {
            league = filteredLeagues[indexPath.row]
        }else{
            league = leagueList[indexPath.row]
        }
        
        if let imageURL = URL(string: league.image){
            cell.legueImage.loadImageFromURL(imageURL)
        }
        cell.legueName.text = league.name
        cell.legueDates.text = league.dates
        
        cell.selectedLeague = {
            
            ScoresViewController.shouldUpdate = true
            
            if let index = self.selectedList.firstIndex(where: { leagueModel in
                return leagueModel.id == league.id
            }){
                self.selectedList.remove(at: index)
            }else{
                self.selectedList.append(league)
            }
            self.setSelectedList()
            self.tableView.reloadData()
        }
        
        if selectedList.contains(where: { leagueModel in
            return leagueModel.id == league.id
        }){
            cell.selectImage.image = #imageLiteral(resourceName: "StarSelect.pdf")
        }else{
            cell.selectImage.image = #imageLiteral(resourceName: "Star.pdf")
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            selectedLeague = filteredLeagues[indexPath.row]
        }else{
            selectedLeague = leagueList[indexPath.row]
        }
        
        searchBar.resignFirstResponder()
        performSegue(withIdentifier: "LeaguesToDetails", sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    
    
}

extension LeaguesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            isSearching = false
        }else{
            isSearching = true
        }
        
        filteredLeagues.removeAll()
        
        for league in leagueList {
            if league.name.lowercased().contains(searchText.lowercased()){
                filteredLeagues.append(league)
            }
        }
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
