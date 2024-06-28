//
//  ScoresDeatilViewController.swift
//  My Score
//
//  Created by admin on 16.04.2024.
//

import UIKit

class ScoresDeatilViewController: UIViewController {
    
    
    @IBOutlet weak var scoreText: UILabel!
    @IBOutlet weak var minuteText: UILabel!
    @IBOutlet weak var homeLogo: UIImageView!
    @IBOutlet weak var homeName: UILabel!
    @IBOutlet weak var awayLogo: UIImageView!
    @IBOutlet weak var awayName: UILabel!
    
    @IBOutlet weak var bestImage: UIImageView!
    @IBOutlet weak var bestName: UILabel!
    
    @IBOutlet weak var coachHomeImage: UIImageView!
    @IBOutlet weak var coachHomeName: UILabel!
    
    @IBOutlet weak var coachAwayImage: UIImageView!
    @IBOutlet weak var coachAwayName: UILabel!
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var dateText: UILabel!
    
    
    var fixtureModel: FixtureModel? = nil
    
    var selectedTeam: Int? = nil
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statBg: UIView!
    var statList = [StatsModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let homeGesture = UITapGestureRecognizer(target: self, action: #selector(homePress(_:)))
        let awayGesture = UITapGestureRecognizer(target: self, action: #selector(awayPress(_:)))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StatCell.nib, forCellReuseIdentifier: StatCell.reuseId)
        
        homeLogo.addGestureRecognizer(homeGesture)
        awayLogo.addGestureRecognizer(awayGesture)
        // Do any additional setup after loading the view.
        setData()
    }
    
    @objc func homePress(_ sender: UITapGestureRecognizer){
        selectedTeam = fixtureModel?.homeId
        performSegue(withIdentifier: "ScoresToTeam", sender: self)
    }
    
    @objc func awayPress(_ sender: UITapGestureRecognizer){
        selectedTeam = fixtureModel?.awayId
        performSegue(withIdentifier: "ScoresToTeam", sender: self)
    }
    
    @IBAction func statSwitched(_ sender: Any) {
        statBg.isHidden = !statBg.isHidden
    }
    
    
    private func setData(){
        
        statBg.isHidden = true
        
        if let fixture = fixtureModel {
            
            ApiManager.getCoach(fixtureId: fixture.id) { it in
                if !it.isEmpty{
                    self.statList.removeAll()
                    self.statList.append(contentsOf: it)
                    
                }else{
                    self.statList.removeAll()
                    self.statList.append(StatsModel(name: "No data available", firstValue: 0, secondValue: 0))
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"

            var seconds = TimeInterval(fixture.date)
            let date = Date(timeIntervalSince1970: seconds!)
            dateText.text = dateFormatter.string(from: date)
            
            leagueName.text = fixture.league
            if let imageURL = URL(string: fixture.homeLogo){
                homeLogo.loadImageFromURL(imageURL)
            }
            if let imageURL = URL(string: fixture.awayLogo){
                awayLogo.loadImageFromURL(imageURL)
            }
            homeName.text = fixture.homeName
            awayName.text = fixture.awayName
            var goalHome = "0"
            var goalAway = "0"
            if !fixture.homeGoals.isEmpty && fixture.homeGoals != "null"{
                goalHome = fixture.homeGoals
            }
            if !fixture.awayGoals.isEmpty && fixture.awayGoals != "null"{
                goalAway = fixture.awayGoals
            }
            
            scoreText.text = "\(goalHome):\(goalAway)"
            
            if fixture.time.isEmpty{
                dateFormatter.dateFormat = "HH:mm"
                minuteText.text = dateFormatter.string(from: date)
            }else if fixture.time == "90"{
                minuteText.text = "FT"
            }else{
                minuteText.text = "\(fixture.time)'"
            }
            
            ApiManager.getCoach(team: fixture.homeId) { player in
                DispatchQueue.main.async {
                    if let imageURL = URL(string: player.photo){
                        self.bestImage.loadImageFromURL(imageURL)
                        self.coachHomeImage.loadImageFromURL(imageURL)
                    }
                    self.bestName.text = player.name
                    self.coachHomeName.text = player.name
                }
            }
            
            ApiManager.getCoach(team: fixture.awayId) { player in
                DispatchQueue.main.async {
                    if let imageURL = URL(string: player.photo){
                        self.coachAwayImage.loadImageFromURL(imageURL)
                    }
                    self.coachAwayName.text = player.name
                }
            }
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    @IBAction func notificationPressed(_ sender: UIButton) {
        checkNotificationAuthorization()
    }
    
    private func checkNotificationAuthorization(){
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized:
                    self.addNotification()
                case .denied:
                    break
                case .notDetermined:
                    self.scheduleNotification { granted in
                        if granted {
                            self.addNotification()
                        }
                    }
                case .provisional:
                    self.addNotification()
                case .ephemeral:
                    break
                @unknown default:
                    break
                }
            }
        }
    
    private func scheduleNotification(_ grantedHandler: @escaping(Bool) -> Void) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    grantedHandler(true)
                } else {
                    grantedHandler(false)
                }
            }
        }
    
    private func addNotification(){
        
        guard let fixture = fixtureModel else { return }
        
        guard let seconds = TimeInterval(fixture.date) else { return }
        
        let date = Date(timeIntervalSince1970: seconds)
        
        let dateComponents: DateComponents
        if #available(iOS 16, *) {
            dateComponents = Calendar.current.dateComponents(in: .gmt, from: date)
        } else {
            
            dateComponents = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: date)
            // Fallback on earlier versions
        }
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "Time to play!"
        content.body = "Game started!"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
        }
        
        
    }
    
        
        // Your function where you want to present the alert
        func showAlert() {
            let alertController = UIAlertController(title: "Success!", message: "We will remind you when it's time for the match.", preferredStyle: .alert)
            
            
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
                // Handle cancel action
                // Perform any cleanup or dismiss the view controller
            }
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    
    @IBAction func sharePressed(_ sender: UIButton) {
        let appURL = "Try this app: FootioX"

                let activityViewController = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)

                // Exclude activities that are not applicable on iOS
                activityViewController.excludedActivityTypes = [
                    .addToReadingList,
                    .assignToContact,
                    .openInIBooks,
                    .postToVimeo,
                    .postToWeibo,
                    .print
                ]

                // Present the UIActivityViewController
                if let popoverController = activityViewController.popoverPresentationController {
                    popoverController.sourceView = view
                    popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }

                present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ScoresToTeam"{
            let destination = segue.destination as! TeamViewController
            destination.teamID = selectedTeam!
        }
    }

}

extension ScoresDeatilViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: StatCell.reuseId, for: indexPath) as! StatCell
        
        cell.nameText.text = statList[indexPath.row].name
        
        if statList[indexPath.row].name != "No data available"{
            
            cell.homeText.isHidden = false
            cell.awayText.isHidden = false
            cell.awayProgress.isHidden = false
            cell.homeProgress.isHidden = false
            
            if let first = Int(statList[indexPath.row].firstValue),
               let second = Int(statList[indexPath.row].secondValue){
                
                cell.homeText.text = "\(first)"
                cell.awayText.text = "\(second)"
                
                let value1 = Double(first) / (Double(first) + Double(second))
                let value2 = Double(second) / (Double(first) + Double(second))
                
                cell.homeProgress.progress = Float(value1)
                cell.awayProgress.progress = Float(value2)
                
            }else{
                cell.homeText.text = "-"
                cell.awayText.text = "-"
                
                cell.homeProgress.progress = 0
                cell.awayProgress.progress = 0
            }
        }else{
            cell.homeText.isHidden = true
            cell.awayText.isHidden = true
            cell.awayProgress.isHidden = true
            cell.homeProgress.isHidden = true
        }
        
        return cell
        
    }
    
    
    
    
}
