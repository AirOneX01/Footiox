//
//  PlayerModel.swift
//  My Score
//
//  Created by admin on 16.04.2024.
//

import Foundation

class PlayerModel {
    var id: Int
    var name: String
    var photo: String

    init(id: Int, name: String, photo: String) {
        self.id = id
        self.name = name
        self.photo = photo
    }
}
