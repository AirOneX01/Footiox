//
//  FixtureModel.swift
//  My Score
//
//  Created by admin on 16.04.2024.
//

import Foundation

class FixtureModel: Codable {
    
    var id: Int
    var date: String
    var time: String
    var homeId: Int
    var homeName: String
    var homeLogo: String
    var awayId: Int
    var awayName: String
    var awayLogo: String
    var homeGoals: String
    var awayGoals: String
    var league: String

    init(
        id: Int,
        date: String,
        time: String,
        homeId: Int,
        homeName: String,
        homeLogo: String,
        awayId: Int,
        awayName: String,
        awayLogo: String,
        homeGoals: String,
        awayGoals: String,
        league: String = ""
    ) {
        self.id = id
        self.date = date
        self.time = time
        self.homeId = homeId
        self.homeName = homeName
        self.homeLogo = homeLogo
        self.awayId = awayId
        self.awayName = awayName
        self.awayLogo = awayLogo
        self.homeGoals = homeGoals
        self.awayGoals = awayGoals
        self.league = league
    }
}
