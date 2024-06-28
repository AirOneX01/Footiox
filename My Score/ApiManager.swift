//
//  ApiManager.swift
//  My Score
//
//  Created by admin on 16.04.2024.
//

import Alamofire
import SwiftyJSON
import Foundation

class ApiManager {
    
    
    private static var dateDict: [String : [LeagueModel]] = [:]
    
    private static var loadFixtureTask: Task<(), Never>? = nil
    private static var oddTask: Task<(), Never>? = nil
    
    
    static func getCoach(team: Int, handler: @escaping (PlayerModel) -> Void) {
        let url = "https://api-football-v1.p.rapidapi.com/v3/coachs?team=\(team)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue("c179e1d670msh931d3cb4faf18ccp18bccajsnc884561fb934", forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue("api-football-v1.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                // Handle the error
                return
            }
            
            guard let data = data else {
                print("No data received.")
                // Handle the case when no data is received
                return
            }
            
            let json = JSON(data)
            if let coach = json["response"].array?.first {
                let playerModel = PlayerModel(
                    id: coach["id"].intValue,
                    name: coach["name"].stringValue,
                    photo: coach["photo"].stringValue
                )
                handler(playerModel)
            }
            
        }.resume()
    }
    
    static func getCoach(fixtureId: Int, handler: @escaping ([StatsModel]) -> Void) {
        let url = "https://api-football-v1.p.rapidapi.com/v3/fixtures/statistics?fixture=\(fixtureId)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue("c179e1d670msh931d3cb4faf18ccp18bccajsnc884561fb934", forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue("api-football-v1.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                handler([])
                // Handle the error
                return
            }
            
            guard let data = data else {
                print("No data received.")
                handler([])
                // Handle the case when no data is received
                return
            }
            
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let jsonList = jsonObject["response"] as? [[String: Any]] {
                    if jsonList.count > 0 {
                        if let firstStatsList = jsonList[0]["statistics"] as? [[String: Any]],
                           let secondStatsList = jsonList[1]["statistics"] as? [[String: Any]] {
                            
                            var statList = [StatsModel]()
                            
                            for i in 0..<firstStatsList.count {
                                let firstJson = firstStatsList[i]
                                let secondJson = secondStatsList[i]
                                
                                if let firstType = firstJson["type"] as? String,
                                   let firstValue = firstJson["value"] as? Int,
                                   let secondValue = secondJson["value"] as? Int {
                                    
                                    let statModel = StatsModel(name: firstType, firstValue: firstValue, secondValue: secondValue)
                                    statList.append(statModel)
                                }
                            }
                            
                            print(statList)
                            handler(statList)
                        } else {
                            handler([])
                            print("Error: Could not find 'statistics' array in one or both teams.")
                        }
                    } else {
                        handler([])
                        print("Error: The 'response' array is empty.")
                    }
                } else {
                    handler([])
                    print("Error: Could not parse 'response' as a JSON array.")
                }
            } catch {
                handler([])
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    
    static func generateFixtures(date: String, handler: @escaping ([LeagueModel]) -> Void) {
        
        loadFixtureTask?.cancel()
        
        loadFixtureTask = Task {
            let selectedLeagues = PListManager.loadSelectedLeaguesFromPlist()
            
            if !selectedLeagues.isEmpty {
                
                
                var leaguesToShow = [LeagueModel]()
                for i in 0..<selectedLeagues.count {
                    var fixtures = try! await getFixturesOdds(league: selectedLeagues[i], date: date, position: i)
                    if !fixtures.isEmpty{
                        selectedLeagues[i].fixtures.removeAll()
                        selectedLeagues[i].fixtures.append(contentsOf: fixtures)
                        leaguesToShow.append(selectedLeagues[i])
                    }
                }
                if !leaguesToShow.isEmpty {
                    handler(leaguesToShow)
                }else{
                    for i in 0..<selectedLeagues.count {
                        var fixtures = try! await getFixturesOdds(league: selectedLeagues[i])
                        if !fixtures.isEmpty{
                            selectedLeagues[i].fixtures.removeAll()
                            selectedLeagues[i].fixtures.append(contentsOf: fixtures)
                            leaguesToShow.append(selectedLeagues[i])
                        }
                    }
                    handler(leaguesToShow)
                }
            } else {
                let fixtures = try! await getNextFixtures(date: date)
                if !fixtures.isEmpty{
                    
                    let league = LeagueModel(id: 0, name: "No leagues selected", dates: "", image: "", season: "All matches for \(date)")
                    league.fixtures = fixtures
                    handler([league])
                    
                }else{
                    
                    let league = LeagueModel(id: 0, name: "No leagues selected", dates: "", image: "", season: "No matches for today")
                    handler([league])
                    
                }
            }
        }
    }
    
    private static func getNextFixtures(date: String) async throws -> [FixtureModel] {
        
        guard let url = URL(string: "https://api-football-v1.p.rapidapi.com/v3/fixtures?date=\(date)") else {
            return []
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("c179e1d670msh931d3cb4faf18ccp18bccajsnc884561fb934", forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue("api-football-v1.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let json = try JSON(data: data)
            
            var fixtures: [FixtureModel] = []
            for (_, fixture):(String, JSON) in json["response"] {
                let fixtureModel = FixtureModel(
                    id: fixture["fixture"]["id"].intValue,
                    date: fixture["fixture"]["timestamp"].stringValue,
                    time: fixture["fixture"]["status"]["elapsed"].stringValue,
                    homeId: fixture["teams"]["home"]["id"].intValue,
                    homeName: fixture["teams"]["home"]["name"].stringValue,
                    homeLogo: fixture["teams"]["home"]["logo"].stringValue,
                    awayId: fixture["teams"]["away"]["id"].intValue,
                    awayName: fixture["teams"]["away"]["name"].stringValue,
                    awayLogo: fixture["teams"]["away"]["logo"].stringValue,
                    homeGoals: fixture["goals"]["home"].stringValue,
                    awayGoals: fixture["goals"]["away"].stringValue,
                    league: fixture["league"]["name"].stringValue
                )
                
                fixtures.append(fixtureModel)
            }
            
            return fixtures
        } catch {
            return []
        }
    }
    
    
    private static func getNextOds() async throws -> [FixtureModel] {
        
        guard let url = URL(string: "https://api-football-v1.p.rapidapi.com/v3/fixtures?next=50") else {
            return []
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("c179e1d670msh931d3cb4faf18ccp18bccajsnc884561fb934", forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue("api-football-v1.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let json = try JSON(data: data)
            
            var fixtures: [FixtureModel] = []
            for (_, fixture):(String, JSON) in json["response"] {
                let fixtureModel = FixtureModel(
                    id: fixture["fixture"]["id"].intValue,
                    date: fixture["fixture"]["timestamp"].stringValue,
                    time: fixture["fixture"]["status"]["elapsed"].stringValue,
                    homeId: fixture["teams"]["home"]["id"].intValue,
                    homeName: fixture["teams"]["home"]["name"].stringValue,
                    homeLogo: fixture["teams"]["home"]["logo"].stringValue,
                    awayId: fixture["teams"]["away"]["id"].intValue,
                    awayName: fixture["teams"]["away"]["name"].stringValue,
                    awayLogo: fixture["teams"]["away"]["logo"].stringValue,
                    homeGoals: fixture["goals"]["home"].stringValue,
                    awayGoals: fixture["goals"]["away"].stringValue,
                    league: fixture["league"]["name"].stringValue
                )
                
                fixtures.append(fixtureModel)
            }
            
            return fixtures
        } catch {
            return []
        }
    }
    
    static func generateOds(handler: @escaping ([FixtureModel]) -> Void) {
        
        oddTask?.cancel()
        
        oddTask = Task {
            let selectedLeagues = PListManager.loadSelectedLeaguesFromPlist()
            var odsList = [FixtureModel]()
            if !selectedLeagues.isEmpty {
                for league in selectedLeagues {
                    let fixtures = try! await getFixturesOdds(league: league)
                    odsList.append(contentsOf: fixtures)
                }
                handler(odsList)
            } else {
                let fixtures = try! await getNextOds()
                handler(fixtures)
            }
        }
    }
    
    private static func getFixturesOdds(league: LeagueModel, date: String? = nil, position: Int? = nil) async throws -> [FixtureModel] {
        var finalURL: URL
        if let date = date {
            guard let url = URL(string: "https://api-football-v1.p.rapidapi.com/v3/fixtures?league=\(league.id)&season=\(league.season)&date=\(date)") else {
                return []
            }
            finalURL = url
        } else {
            guard let url = URL(string: "https://api-football-v1.p.rapidapi.com/v3/fixtures?league=\(league.id)&season=\(league.season)&next=30") else {
                // Handle the case when the URL is invalid
                return []
            }
            finalURL = url
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        request.setValue("c179e1d670msh931d3cb4faf18ccp18bccajsnc884561fb934", forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue("api-football-v1.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let json = try JSON(data: data)
            
            var fixtures: [FixtureModel] = []
            
            for (_, fixture):(String, JSON) in json["response"] {
                let fixtureModel = FixtureModel(
                    id: fixture["fixture"]["id"].intValue,
                    date: fixture["fixture"]["timestamp"].stringValue,
                    time: fixture["fixture"]["status"]["elapsed"].stringValue,
                    homeId: fixture["teams"]["home"]["id"].intValue,
                    homeName: fixture["teams"]["home"]["name"].stringValue,
                    homeLogo: fixture["teams"]["home"]["logo"].stringValue,
                    awayId: fixture["teams"]["away"]["id"].intValue,
                    awayName: fixture["teams"]["away"]["name"].stringValue,
                    awayLogo: fixture["teams"]["away"]["logo"].stringValue,
                    homeGoals: fixture["goals"]["home"].stringValue,
                    awayGoals: fixture["goals"]["away"].stringValue,
                    league: league.name
                )
                
                fixtures.append(fixtureModel)
            }
            
            return fixtures
        } catch {
            return []
        }
    }
    
    
    
    static func loadTeams(id: Int, completion: @escaping (TeamModel?) -> Void) {
        
        let headers = [
            "X-RapidAPI-Key": "c179e1d670msh931d3cb4faf18ccp18bccajsnc884561fb934",
            "X-RapidAPI-Host": "api-football-v1.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api-football-v1.p.rapidapi.com/v3/teams?id=\(id)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion(nil)
                return
            }
            do {
                let json = try JSON(data: data)
                
                var teamList = [TeamModel]()
                for (_, team):(String, JSON) in json["response"] {
                    
                    
                    let team = TeamModel(id: team["team"]["id"].intValue,
                                         name: team["team"]["name"].stringValue,
                                         code: team["team"]["code"].stringValue,
                                         country: team["team"]["country"].stringValue,
                                         national: team["team"]["national"].boolValue,
                                         logo: team["team"]["logo"].stringValue,
                                         year: team["team"]["founded"].stringValue)
                    teamList.append(team)
                }
                
                if !teamList.isEmpty{
                    completion(teamList[0])
                }
                
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        })
        
        dataTask.resume()
        
    }
    
    static func loadLeagues(completion: @escaping ([LeagueModel]?) -> Void) {
        
        let headers = [
            "X-RapidAPI-Key": "c179e1d670msh931d3cb4faf18ccp18bccajsnc884561fb934",
            "X-RapidAPI-Host": "api-football-v1.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api-football-v1.p.rapidapi.com/v3/leagues?current=true")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion(nil)
                return
            }
            do {
                let json = try JSON(data: data)
                var leagueList: [LeagueModel] = []
                
                print(json.stringValue)
                for (_, league):(String, JSON) in json["response"] {
                    var dates = "Unknown"
                    var year = "2024"
                    
                    if let season = league["seasons"].array?.last {
                        dates = "\(season["start"].stringValue.replacingOccurrences(of: "-", with: "."))-\(season["end"].stringValue.replacingOccurrences(of: "-", with: "."))"
                        year = season["year"].stringValue
                    }
                    
                    let leagueModel = LeagueModel(
                        id: league["league"]["id"].intValue,
                        name: league["league"]["name"].stringValue,
                        dates: dates,
                        image: league["league"]["logo"].stringValue,
                        season: year
                        
                    )
                    
                    leagueList.append(leagueModel)
                }
                
                leagueList.reverse()
                completion(leagueList)
                
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        })
        
        dataTask.resume()
        
    }
    
}


