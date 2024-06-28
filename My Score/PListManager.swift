//
//  PListManager.swift
//  My Score
//
//  Created by admin on 16.04.2024.
//

import UIKit

class PListManager {
    
    // MARK: - Save to .plist
    
    static func saveSelectedLeaguesToPlist(leagues: [LeagueModel]) {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(leagues)
            try data.write(to: leagueModelPlistURL())
        } catch {
            print("Error encoding and saving leagues: \(error)")
        }
    }
    
    // MARK: - Load from .plist
    
    static func loadSelectedLeaguesFromPlist() -> [LeagueModel] {
        if let data = try? Data(contentsOf: leagueModelPlistURL()) {
            let decoder = PropertyListDecoder()
            do {
                let leagues = try decoder.decode([LeagueModel].self, from: data)
                return leagues
            } catch {
                print("Error decoding leagues from plist: \(error)")
            }
        }
        return []
    }
    
    // MARK: - Helper Methods
    
    private static func leagueModelPlistURL() -> URL {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to get documents directory URL.")
        }
        return documentsURL.appendingPathComponent("leagues.plist")
    }
    
    // MARK: - Ob save
    
    static func isObShowed() -> Bool{
        return UserDefaults.standard.bool(forKey: "OB_SHOW")
    }
    
    static func setObShown(){
        UserDefaults.standard.set(true, forKey: "OB_SHOW")
    }
    
    static func isPreScreenShowed() -> Bool{
        return UserDefaults.standard.bool(forKey: "PRE_SHOW")
    }
    
    static func setPreScreenShowed(){
        UserDefaults.standard.set(true, forKey: "PRE_SHOW")
    }
}
