//
//  VotesViewController.swift
//  My Score
//
//  Created by admin on 16.04.2024.
//

import UIKit

class VotesViewController: UIViewController {

    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var awayImage: UIImageView!
    @IBOutlet weak var homeImage2: UIImageView!
    @IBOutlet weak var awayImage2: UIImageView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var drawView: UILabel!
    
    var fixtureList: [FixtureModel] = []
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getList()
    }
    
    private func getList(){
        loadingView.isHidden = false
        drawView.isHidden = true
        ApiManager.generateOds { list in
            DispatchQueue.main.async {
                self.fixtureList.removeAll()
                self.fixtureList.append(contentsOf: list)
                self.setItem()
                self.loadingView.isHidden = true
                self.drawView.isHidden = false
            }
        }
    }
    
    private func setItem(){
        if !fixtureList.isEmpty{
            var fixture = fixtureList[counter]
            if let imageURL = URL(string: fixture.homeLogo){
                homeImage.loadImageFromURL(imageURL)
                homeImage2.loadImageFromURL(imageURL)
            }
            if let imageURL = URL(string: fixture.awayLogo){
                awayImage.loadImageFromURL(imageURL)
                awayImage2.loadImageFromURL(imageURL)
            }
        }
        
    }
    
    @IBAction func votePressed(_ sender: UIButton) {
        counter+=1
        if(counter >= fixtureList.count){
            counter = 0
        }
        setItem()
    }
    
    @IBAction func detailPressed(_ sender: UIButton) {
        if !fixtureList.isEmpty{
            performSegue(withIdentifier: "VotingToDetail", sender: self)
        }
    }
    
    
    @IBAction func scoresPressed(_ sender: UIButton) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VotingToDetail"{
            let destination = segue.destination as! VotesDetailsViewController
            destination.fixtureModel = fixtureList[counter]
        }
    }
    

}
