//
//  ShowPreviewData.swift
//  PoketDex
//
//  Created by Aman Giri on 2024-04-15.
//

import Foundation
import CoreData

struct ShowPreviewData {
    static var samplePokemon = {
        let context = PersistenceController.shared.container.viewContext
        let fetchPokemon: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchPokemon.fetchLimit = 1
        return try! context.fetch(fetchPokemon).first!
    }()
}
