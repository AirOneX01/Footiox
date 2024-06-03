//
//  LeagueModel.swift
//  My Score
//
//  Created by admin on 16.04.2024.
//

import Foundation


class LeagueModel: Codable {
    var id: Int
    var name: String
    var dates: String
    var image: String
    var season: String
    var fixtures: [FixtureModel] = []
    
    init(id: Int, name: String, dates: String, image: String, season: String) {
        self.id = id
        self.name = name
        self.dates = dates
        self.image = image
        self.season = season
    }
     
    
}
