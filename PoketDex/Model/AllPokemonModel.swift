//
//  AllPokemonModel.swift
//  PoketDex
//
//  Created by Aman Giri on 2024-04-15.
//

import Foundation

struct AllPokemonModel: Codable {
    let results: [Results]
}

struct Results: Codable {
    let name: String
    let url: URL
}
