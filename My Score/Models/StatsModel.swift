//
//  StatsModel.swift
//  My Score
//
//  Created by Air One on 6/27/24.
//

import Foundation

class StatsModel{
    
    var name: String
    var firstValue: String
    var secondValue: String
    
    init(name: String, firstValue: Int, secondValue: Int) {
        self.name = name
        self.firstValue = "\(firstValue)"
        self.secondValue = "\(secondValue)"
    }
    
}
