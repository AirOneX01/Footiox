//
//  ScoresViewController.swift
//  My Score
//
//  Created by admin on 16.04.2024.
//

import UIKit

class ScoresViewController: UIViewController {
    
    
    static var shouldUpdate = false
    
    @IBOutlet weak var yesterdayView: UIView!
    @IBOutlet weak var yesterdayText: UILabel!
    @IBOutlet weak var todayView: UIView!
    @IBOutlet weak var todayText: UILabel!
    @IBOutlet weak var tomorrowView: UIView!
    @IBOutlet weak var tommorowText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIStackView!
    
    
    
    var showLaunch = true
    var leagueList: [LeagueModel] = []
    var selectedFixture: FixtureModel? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FixtureCell.nib, forCellReuseIdentifier: FixtureCell.reuseId)
        tableView.register(HeaderCell.nib, forCellReuseIdentifier: HeaderCell.reuseId)
        
        // Do any additional setup after loading the view.
        ScoresViewController.shouldUpdate = true
    }
    
    private func getList(date: String){
        
        UIView.animate(withDuration: 0.3) {
            self.loadingView.isHidden = false
        }
        ApiManager.generateFixtures(date: date) { list in
            DispatchQueue.main.async {
                self.leagueList.removeAll()
                self.leagueList.append(contentsOf: list)
                self.tableView.reloadData()
                UIView.animate(withDuration: 0.3) {
                    self.loadingView.isHidden = true
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        if showLaunch {
            showLaunch = false
            performSegue(withIdentifier: "MainToOnb", sender: self)
        }
        if ScoresViewController.shouldUpdate {
            ScoresViewController.shouldUpdate = false
            setToday()
        }
    }
    
    @IBAction func callendarPressed(_ sender: UIButton) {
        let datePicker = UIDatePicker()
                datePicker.datePickerMode = .date // Choose the desired mode

                let alertController = UIAlertController(title: "\n\n", message: nil, preferredStyle: .actionSheet)

                alertController.view.addSubview(datePicker)
                datePicker.translatesAutoresizingMaskIntoConstraints = false
                datePicker.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 16).isActive = true
                datePicker.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor).isActive = true

                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    let selectedDate = datePicker.date
                    self.setCustom(date: selectedDate)
                }

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                alertController.addAction(okAction)
                alertController.addAction(cancelAction)

                // Check if the device is iPad
                if UIDevice.current.userInterfaceIdiom == .pad {
                    // If iPad, configure popover presentation
                    if let popoverPresentationController = alertController.popoverPresentationController {
                        popoverPresentationController.sourceView = self.view // Set the source view
                        popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // Set the source rect
                        popoverPresentationController.permittedArrowDirections = [] // Optionally, you can specify the arrow direction
                    }
                }

                present(alertController, animated: true, completion: nil)
    }
    
    func setCustom(date: Date) {
        tommorowText.textColor = UIColor(named: "MainText")
        tomorrowView.backgroundColor = UIColor(named: "Background")
        yesterdayText.textColor = UIColor(named: "MainText")
        yesterdayView.backgroundColor = UIColor(named: "Background")
        todayText.textColor = UIColor(named: "MainText")
        todayView.backgroundColor = UIColor(named: "Background")
        // Update your UI or performother actions with the selected date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        getList(date: dateString)
    }
    
    @IBAction func tomorrowPressed(_ sender: UIButton) {
        setTomorrow()
    }
    
    private func setTomorrow(){
        
        tommorowText.textColor = UIColor(named: "Background")
        tomorrowView.backgroundColor = UIColor(named: "TopSelect")
        yesterdayText.textColor = UIColor(named: "MainText")
        yesterdayView.backgroundColor = UIColor(named: "Background")
        todayText.textColor = UIColor(named: "MainText")
        todayView.backgroundColor = UIColor(named: "Background")
        
        let currentDate = Date()
        let calendar = Calendar.current
        if let yesterday = calendar.date(byAdding: .day, value: 1, to: currentDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.string(from: yesterday)
            getList(date: formattedDate)
        } else {
            print("Error calculating yesterday's date.")
        }
    }
    
    
    @IBAction func todayPressed(_ sender: UIButton) {
        setToday()
    }
    
    private func setToday(){
        
        tommorowText.textColor = UIColor(named: "MainText")
        tomorrowView.backgroundColor = UIColor(named: "Background")
        yesterdayText.textColor = UIColor(named: "MainText")
        yesterdayView.backgroundColor = UIColor(named: "Background")
        todayText.textColor = UIColor(named: "Background")
        todayView.backgroundColor = UIColor(named: "TopSelect")
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: currentDate)
        getList(date: formattedDate)
    }
    
    
    @IBAction func yesterdayPressed(_ sender: UIButton) {
        setYesterday()
    }
    
    private func setYesterday(){
        
        tommorowText.textColor = UIColor(named: "MainText")
        tomorrowView.backgroundColor = UIColor(named: "Background")
        yesterdayText.textColor = UIColor(named: "Background")
        yesterdayView.backgroundColor = UIColor(named: "TopSelect")
        todayText.textColor = UIColor(named: "MainText")
        todayView.backgroundColor = UIColor(named: "Background")
        
        let currentDate = Date()
        let calendar = Calendar.current
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: currentDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.string(from: yesterday)
            getList(date: formattedDate)
        } else {
            print("Error calculating yesterday's date.")
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScoreToDetail"{
            let destination = segue.destination as! ScoresDeatilViewController
            destination.fixtureModel = selectedFixture
        }
    }

}

extension ScoresViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return leagueList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagueList[section].fixtures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FixtureCell.reuseId, for: indexPath) as! FixtureCell
        
        cell.homeName.text = leagueList[indexPath.section].fixtures[indexPath.row].homeName
        cell.awayName.text = leagueList[indexPath.section].fixtures[indexPath.row].awayName
        
        var time = leagueList[indexPath.section].fixtures[indexPath.row].time
        cell.playedStar.image = #imageLiteral(resourceName: "Star.pdf")
        if time.isEmpty{
            
            cell.dateText.isHidden = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            var seconds = TimeInterval(leagueList[indexPath.section].fixtures[indexPath.row].date)
            let date = Date(timeIntervalSince1970: seconds!)
            cell.dateText.text = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "HH:mm"
            cell.statusText.text = dateFormatter.string(from: date)
        }else if time == "90"{
            cell.dateText.isHidden = true
            cell.statusText.text = "FT"
        }else{
            cell.dateText.isHidden = true
            cell.statusText.text = "\(leagueList[indexPath.section].fixtures[indexPath.row].time)'"
            cell.playedStar.image = #imageLiteral(resourceName: "StarSelect.pdf")
        }
        
        if leagueList[indexPath.section].fixtures[indexPath.row].homeGoals.isEmpty || leagueList[indexPath.section].fixtures[indexPath.row].homeGoals == "nil"{
            cell.homeScore.text = "0"
        }else{
            cell.homeScore.text = leagueList[indexPath.section].fixtures[indexPath.row].homeGoals
        }
        if leagueList[indexPath.section].fixtures[indexPath.row].awayGoals.isEmpty || leagueList[indexPath.section].fixtures[indexPath.row].awayGoals == "nil"{
            cell.awayScore.text = "0"
        }else{
            cell.awayScore.text = leagueList[indexPath.section].fixtures[indexPath.row].awayGoals
        }
        
        if let imageURL = URL(string: leagueList[indexPath.section].fixtures[indexPath.row].homeLogo){
            cell.homeImage.loadImageFromURL(imageURL)
        }
        if let imageURL = URL(string: leagueList[indexPath.section].fixtures[indexPath.row].awayLogo){
            cell.awayImage.loadImageFromURL(imageURL)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.red
        
        // Dequeue the reusable header cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.reuseId) as? HeaderCell else {
            // Handle cell dequeuing failure
            return nil
        }
        
        // Configure the header cell
        if leagueList[section].image.isEmpty {
            cell.leagueImage.image = #imageLiteral(resourceName: "StarSelect")
            cell.leagueSeason.text = "\(leagueList[section].season)"
        }else{
            if let imageURL = URL(string: leagueList[section].image) {
                cell.leagueImage.loadImageFromURL(imageURL)
            }
            cell.leagueSeason.text = "Season: \(leagueList[section].season)"
        }
        cell.leagueName.text = leagueList[section].name
       
        
        // Set the cell's frame to match the width of the table view
        cell.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(70)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFixture = leagueList[indexPath.section].fixtures[indexPath.row]
        performSegue(withIdentifier: "ScoreToDetail", sender: self)
    }
    
}
