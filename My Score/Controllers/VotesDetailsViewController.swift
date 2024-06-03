//
//  VotesDetailsViewController.swift
//  My Score
//
//  Created by admin on 16.04.2024.
//

import UIKit

class VotesDetailsViewController: UIViewController {

    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var homeTeam: UIImageView!
    @IBOutlet weak var awayTeam: UIImageView!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var winnerText: UILabel!
    @IBOutlet weak var goalsText: UILabel!
    @IBOutlet weak var bothWinText: UILabel!
    @IBOutlet weak var finalScoreText: UILabel!
    
    var fixtureModel: FixtureModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
    }
    
    private func setUI(){
        if let fixture = fixtureModel{
            leagueName.text = fixture.league
            if let imageURL = URL(string: fixture.homeLogo){
                homeTeam.loadImageFromURL(imageURL)
            }
            if let imageURL = URL(string: fixture.awayLogo){
                awayTeam.loadImageFromURL(imageURL)
            }
            if let millis = Int(fixture.date){
                dateText.text = convertMillisecondsToDate(milliseconds: millis)
            }
            if fixture.time != "null" && !fixture.time.isEmpty{
                statusText.text = "\(fixture.time)'"
            }else{
                statusText.text = "NS"
            }
            if Int.random(in: (0...1)) == 1{
                winnerText.text = fixture.awayName
            }else{
                winnerText.text = fixture.homeName
            }
            if Int.random(in: (0...1)) == 1{
                bothWinText.text = "Yes"
            }else{
                bothWinText.text = "No"
            }
            var goalFirst = Int.random(in: (0...7))
            var goalSecond = Int.random(in: (0...7))
            
            finalScoreText.text = "\(goalFirst):\(goalSecond)"
            goalsText.text = "\(goalFirst + goalSecond)"
        }
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
    
    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    func convertMillisecondsToDate(milliseconds: Int) -> String {
        // Convert milliseconds to seconds
        let seconds = TimeInterval(milliseconds)
        
        // Create a Date object from seconds
        let date = Date(timeIntervalSince1970: seconds)
        
        // Create a DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensure a specific locale
        
        // Format the date to a string
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
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

