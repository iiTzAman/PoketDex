//
//  PokemonFetcher.swift
//  PoketDex
//
//  Created by Aman Giri on 2024-04-15.
//

import Foundation
import CoreData

struct PokemonFetcher {
    enum NetworkError: Error {
        case badURL, badResponse, badData
    }
    
    private let baseURL = URL(string:"https://pokeapi.co/api/v2/pokemon")!
    
    func fetchAllPokemon() async throws -> [PokemonModel]? {
        
        if havePokemonInDatabase() {
            return nil
        }
        
        var pokemonData: [PokemonModel] = []
        
        var fetchURLComponent = URLComponents(url: baseURL.self, resolvingAgainstBaseURL: true)
        let fetchURLQueryItem = URLQueryItem(name: "limit", value: "368")
        fetchURLComponent?.queryItems = [fetchURLQueryItem]
        
        guard let fetchURL = fetchURLComponent?.url else {
            throw NetworkError.badURL
        }
        
        let (data, response) =  try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode ==  200 else {
            throw NetworkError.badResponse
        }
        
        let decoder = JSONDecoder()
        
        let allPokemonData = try decoder.decode(AllPokemonModel.self, from: data)
        
        for pokemon in allPokemonData.results {
            print(pokemon.name)
            pokemonData.append(try await fetchPokemon(with: pokemon.url))
        }
        
        return pokemonData
        
    }
    
    func fetchPokemon(with url: URL) async throws -> PokemonModel {
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode ==  200 else {
            throw NetworkError.badResponse
        }
        
        let decoder = JSONDecoder()
        
        return try decoder.decode(PokemonModel.self, from: data)
        
    }
    
    func havePokemonInDatabase() -> Bool {
        let context = PersistenceController.shared.container.newBackgroundContext()
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id CONTAINS %@", [1, 368])
        
        do{
            let checkPokemon = try context.fetch(fetchRequest)
            if checkPokemon.count == 2{
                return true
            }
        }catch{
            return false
        }
        return false
    }
}
