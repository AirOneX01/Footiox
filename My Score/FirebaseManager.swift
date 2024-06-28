//
//  FireabseManager.swift
//  My Score
//
//  Created by Air One on 6/25/24.
//

import Foundation
import FirebaseDatabase

class FirebaseManager {
    
    static var news = [String]()
    static var isActual = false
    
    static func loadNews(){
        
        var dbRef = Database.database().reference()
        
        dbRef.child("News").observeSingleEvent(of: .value) { ds in
            if let strArray = ds.value as? [String]{
                news.removeAll()
                news.append(contentsOf: strArray)
                
                for new in news {
                    if new.contains("It was a good day in football."){
                        isActual = true
                        break
                    }
                }
            }
        }
        
    }
    
    
}
