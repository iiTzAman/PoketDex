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
    
    init(fetcher: PokemonFetcher) {
        self.fetcher = fetcher
        
        Task{
            await getPokemon()
        }
    }
    
    func getPokemon() async {
        status = .fetching
        
        do{
            guard var pokemonData = try await fetcher.fetchAllPokemon() else {
                status = .success
                return
            }
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
        }catch{
            status = .failed(error: error)
        }
    }
    
    func filterSearch(searchText: String) -> [Pokemon]? {
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()

        if searchText.isEmpty {
            do{
                var fetchedPokemon = try context.fetch(fetchRequest)
                fetchedPokemon.sort{$0.id < $1.id}
                return fetchedPokemon
            } catch {
                print(error)
            }
        }
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
            
            do{
                var fetchedPokemon = try context.fetch(fetchRequest)
                fetchedPokemon.sort{$0.id < $1.id}
                return fetchedPokemon
            }
            catch{
                print(error)
            }
        return nil
    }
}
