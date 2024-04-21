//
//  PokemonViewModel.swift
//  PoketDex
//
//  Created by Aman Giri on 2024-04-15.
//

import Foundation
import CoreData

@MainActor
class PokemonViewModel: ObservableObject {
    
    enum Status {
        case notStarted
        case fetching
        case success
        case failed(error: Error)
    }
    
    @Published private(set) var status: Status = .notStarted
    
    private let fetcher: PokemonFetcher
    private let context = PersistenceController.shared.container.viewContext
    
    var pokedexData: [Pokemon] = []
    var pokeDex: [Pokemon] = []
    
    init(fetcher: PokemonFetcher) {
        self.fetcher = fetcher
        Task{
            await getPokemon()
        }
    }
    
    func getPokemon() async {
        status = .fetching
        do{
            if var pokemonData = try await fetcher.fetchAllPokemon() {
                pokemonData.sort{$0.id < $1.id}
                for pokemon in pokemonData {
                    let pokemonDatabase = Pokemon(context: context)
                    pokemonDatabase.id = Int16(pokemon.id)
                    pokemonDatabase.attack = Int16(pokemon.attack)
                    pokemonDatabase.defense = Int16(pokemon.defense)
                    pokemonDatabase.favorite = pokemon.favorite
                    pokemonDatabase.height = Int16(pokemon.height)
                    pokemonDatabase.hp = Int16(pokemon.hp)
                    pokemonDatabase.icon = pokemon.icon
                    pokemonDatabase.moves = pokemon.moves
                    pokemonDatabase.name = pokemon.name
                    pokemonDatabase.specialAttack = Int16(pokemon.specialAttack)
                    pokemonDatabase.specialDefense = Int16(pokemon.specialDefense)
                    pokemonDatabase.speed = Int16(pokemon.speed)
                    pokemonDatabase.sprite = pokemon.sprite
                    pokemonDatabase.types = pokemon.types
                    pokemonDatabase.weight = Int16(pokemon.weight)
                    pokedexData.append(pokemonDatabase)
                    try context.save()
                }
                status = .success
            }
            status = .success
        }catch{
            status = .failed(error: error)
        }
    }
    
    func filterSearch(searchText: String) -> [Pokemon] {
        if searchText.isEmpty {
            return pokeDex
        } else {
            var newPokedex: [Pokemon] = []
            for pokemon in pokeDex {
                if pokemon.name!.localizedCaseInsensitiveContains(searchText) {
                    newPokedex.append(pokemon)
                }
            }
            pokeDex = newPokedex
            return pokeDex
        }
    }
    
    func getAllTypes() -> [String] {
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        let fetchedData = try! context.fetch(fetchRequest)
        var pokemonTypes: [String] = []
        
        for pokemon in fetchedData {
            for types in pokemon.types! {
                pokemonTypes.append(types)
            }
        }
        let uniqueTypes = Set(pokemonTypes)
        return Array(uniqueTypes).sorted()
    }
    
    func getAllFavoritePokemon() -> [Pokemon]{
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        let fetchedData = try! context.fetch(fetchRequest)
        var favoritePokemon: [Pokemon] = []
        for pokemon in fetchedData {
            if pokemon.favorite{
                favoritePokemon.append(pokemon)
                print("\(pokemon.favorite)")
            }
        }
        return favoritePokemon
    }
    
    func filterByType(type: String){
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        if type.lowercased() == "all" {
            do{
                let fetchedPokemon = try context.fetch(fetchRequest)
                pokeDex = fetchedPokemon
            } catch {
                print(error)
            }
        } else {
            do{
                pokeDex = []
                let fetchedPokemon = try context.fetch(fetchRequest)
                for pokemon in fetchedPokemon{
                    for poketype in pokemon.types! {
                        if poketype == type {
                            pokeDex.append(pokemon)
                        }
                    }
                }
            }catch{
                print("Error fetching pokemon for the \(type) ")
            }
        }
    }
}
