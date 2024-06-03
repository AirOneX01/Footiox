//
//  TeamModel.swift
//  My Score
//
//  Created by admin on 25.04.2024.
//

import Foundation

class TeamModel: Identifiable, Codable {
    var id: Int
    var name: String
    var logo: String
    var year: String
    
    init(id: Int, name: String, logo: String, year: String) {
        self.id = id
        self.name = name
        self.logo = logo
        self.year = year
    }
}

