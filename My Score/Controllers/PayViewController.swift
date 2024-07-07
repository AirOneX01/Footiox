//
//  PayViewController.swift
//  My Score
//
//  Created by Air One on 6/23/24.
//

import UIKit
import StoreKit

class PayViewController: UIViewController {
    
    @IBOutlet weak var weekSelected: UIView!
    @IBOutlet weak var monthSelected: UIView!
    @IBOutlet weak var yearSelected: UIView!
    
    @IBOutlet weak var weekPrice: UILabel!
    @IBOutlet weak var weekBg: UIView!
    
    @IBOutlet weak var monthPrice: UILabel!
    @IBOutlet weak var monthBg: UIView!
    
    @IBOutlet weak var yearPrice: UILabel!
    @IBOutlet weak var yearBg: UIView!
    
    
    var month: Product!
    var week: Product!
    var year: Product!
    
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PurchaseManager.shared.getWeek { product in
            
            self.week = product
            
            DispatchQueue.main.async { [self] in
                weekPrice.text = product.displayPrice
            }
            
        }
        
        PurchaseManager.shared.getMonth { product in
            
            self.month = product
            
           
            DispatchQueue.main.async { [self] in
                yearPrice.text = product.displayPrice
            }
            
        }
        
        PurchaseManager.shared.getYear { product in
            
            self.year = product
            
            if product == nil {
                self.product = self.year
            }
            
            
            DispatchQueue.main.async { [self] in
                monthPrice.text = product.displayPrice
            }
            
        }
        
        setMonth()
        // Do any additional setup after loading the view.
    }
    
    private func setWeekSelect(){
        weekBg.backgroundColor = UIColor(resource: .paySelect)
        weekSelected.isHidden = false
    }
    private func setWeekUnselect(){
        weekBg.backgroundColor = UIColor(resource: .payNoSelect)
        weekSelected.isHidden = true
    }
    
    private func setMonthSelect(){
        monthBg.backgroundColor = UIColor(resource: .paySelect)
        monthSelected.isHidden = false
    }
    private func setMonthUnselect(){
        monthBg.backgroundColor = UIColor(resource: .payNoSelect)
        monthSelected.isHidden = true
    }
    
    private func setYearSelect(){
        yearBg.backgroundColor = UIColor(resource: .paySelect)
        yearSelected.isHidden = false
    }
    private func setYearUnselect(){
        yearBg.backgroundColor = UIColor(resource: .payNoSelect)
        yearSelected.isHidden = true
    }
    
    private func setWeek(){
        
        setWeekSelect()
        setMonthUnselect()
        setYearUnselect()
        
    }
    
    private func setMonth(){
        
        setWeekUnselect()
        setMonthSelect()
        setYearUnselect()
        
    }
    
    private func setYear(){
        
        setWeekUnselect()
        setMonthUnselect()
        setYearSelect()
        
    }
    
    @IBAction func yearPressed(_ sender: Any) {
        setYear()
        product = month
    }
    
    @IBAction func monthPressed(_ sender: Any) {
        setMonth()
        product = year
    }
    
    @IBAction func weekPressed(_ sender: Any) {
        setWeek()
        product = week
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: true)
    }
    
    @IBAction func subscribePressed(_ sender: Any) {
        if let pr = product {
            PurchaseManager.shared.purchase(pr) { result in
                
            }
        }
    }
    
    @IBAction func termsPress(_ sender: Any) {
        
        if let url = URL(string: "https://sites.google.com/view/footio/terms-of-service") {
            openURL(url)
        } else {
            print("Invalid URL")
        }
    }
    
    @IBAction func policyPress(_ sender: Any) {
        
        if let url = URL(string: "https://sites.google.com/view/footiox/1") {
            openURL(url)
        } else {
            print("Invalid URL")
        }
    }
    
    func openURL(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Cannot open URL")
        }
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
