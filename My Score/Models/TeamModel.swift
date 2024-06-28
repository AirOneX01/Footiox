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
    var code: String
    var country: String
    var national: Bool
    var logo: String
    var year: String
    
    init(id: Int, name: String, code: String, country: String, national: Bool, logo: String, year: String) {
        self.id = id
        self.name = name
        self.code = code
        self.country = country
        self.national = national
        self.logo = logo
        self.year = year
    }
    
    
}

