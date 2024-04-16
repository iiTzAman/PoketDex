//
//  Persistence.swift
//  PoketDex
//
//  Created by Aman Giri on 2024-04-15.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let previewPokemon = Pokemon(context: viewContext)
        previewPokemon.name = "Bulbasaur"
        previewPokemon.id = 1
        previewPokemon.attack = 45
        previewPokemon.defense = 45
        previewPokemon.favorite = true
        previewPokemon.height = 10
        previewPokemon.hp = 200
        previewPokemon.icon = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/1.png")
        previewPokemon.specialAttack = 45
        previewPokemon.specialDefense = 45
        previewPokemon.speed = 40
        previewPokemon.sprite = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")
        previewPokemon.types = ["grass", "poison"]
        previewPokemon.weight = 80
        previewPokemon.moves = ["Headbutt", "Scratch"]
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PoketDex")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
