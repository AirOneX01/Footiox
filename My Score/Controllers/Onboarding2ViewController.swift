//
//  Onboarding2ViewController.swift
//  My Score
//
//  Created by Air One on 6/23/24.
//

import UIKit

class Onboarding2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goPressed(_ sender: Any) {
        
        PListManager.setObShown()
        self.view.window!.rootViewController?.dismiss(animated: true)
        
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
