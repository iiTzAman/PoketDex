//
//  PokemonExtension.swift
//  PoketDex
//
//  Created by Aman Giri on 2024-04-17.
//

import Foundation

extension Pokemon {
    var stats: [StatsModel] {
        [
            StatsModel(id:1, name: "hp", value: self.hp),
            StatsModel(id:2, name: "attack", value: self.attack),
            StatsModel(id: 3, name: "defense", value: self.defense),
            StatsModel(id: 4, name: "special attack", value: self.specialDefense),
            StatsModel(id: 5, name: "special defense", value: self.specialDefense),
            StatsModel(id: 5, name: "speed", value: self.speed)
        ]
    }
    
    var highestStat: StatsModel {
        stats.max{$0.value < $1.value}!
    }
}
