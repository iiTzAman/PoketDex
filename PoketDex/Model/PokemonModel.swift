//
//  PokemonDataModel.swift
//  PoketDex
//
//  Created by Aman Giri on 2024-04-15.
//

import Foundation

struct PokemonModel: Codable {
    let id: Int
    let name: String
    var hp: Int = 0
    var attack: Int = 0
    var defense: Int = 0
    var specialAttack: Int = 0
    var specialDefense: Int = 0
    var speed: Int = 0
    let favorite: Bool
    let height: Int
    let weight: Int
    let icon: URL
    let sprite: URL
    let moves: [String]
    let types: [String]
    
    enum PokemonKeys: String, CodingKey {
        case id
        case name
        case height
        case weight
        case stats
        case sprites
        case moves
        case types
        
        enum StatsDictionaryKeys: String, CodingKey {
            case value = "base_stat"
            case stat
            
            enum StatKeys: String, CodingKey {
                case name
            }
        }
        
        enum SpriteKeys: String, CodingKey {
            case other
            
            enum OtherKeys: String, CodingKey {
                case home = "home"
                case official = "official-artwork"
                
                enum HomeKeys: String, CodingKey {
                    case front = "front_default"
                }
                
                enum OfficialKeys: String, CodingKey {
                    case front = "front_default"
                }
            }
        }
        
        enum MovesDictionaryKeys: String, CodingKey {
            case move
            
            enum MoveKeys: String, CodingKey {
                case name
            }
        }
        
        enum TypesDictionaryKeys: String, CodingKey {
            case type
            
            enum TypeKeys: String, CodingKey {
                case name
            }
        }
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        height = try container.decode(Int.self, forKey: .height)
        weight = try container.decode(Int.self, forKey: .weight)
        favorite = false
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        
        while !statsContainer.isAtEnd {
            let statsDictContainer =  try statsContainer.nestedContainer(keyedBy: PokemonKeys.StatsDictionaryKeys.self)
            let statContainer = try statsDictContainer.nestedContainer(keyedBy: PokemonKeys.StatsDictionaryKeys.StatKeys.self, forKey: .stat)
            
            switch try statContainer.decode(String.self, forKey: .name){
            case "hp":
                hp = try statsDictContainer.decode(Int.self, forKey: .value)
            case "attack":
                attack = try statsDictContainer.decode(Int.self, forKey: .value)
            case "defense":
                defense = try statsDictContainer.decode(Int.self, forKey: .value)
            case "special-attack":
                specialAttack = try statsDictContainer.decode(Int.self, forKey: .value)
            case "special-defense":
                specialDefense = try statsDictContainer.decode(Int.self, forKey: .value)
            case "speed":
                speed = try statsDictContainer.decode(Int.self, forKey: .value)
            default:
                print("Something happened!!")
            }
        }
        
        let spritesContainer =  try container.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.self, forKey: .sprites)
        let otherContainer = try spritesContainer.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.OtherKeys.self, forKey: .other)
        let homeContainer = try otherContainer.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.OtherKeys.HomeKeys.self, forKey: .home)
        let officialContainer = try otherContainer.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.OtherKeys.OfficialKeys.self, forKey: .official)
        sprite = try officialContainer.decode(URL.self, forKey: .front)
        icon = try homeContainer.decode(URL.self, forKey: .front)
        
        var movesList: [String] = []
        var movesContainer = try container.nestedUnkeyedContainer(forKey: .moves)
        
        while !movesContainer.isAtEnd {
            let movesDictionary = try movesContainer.nestedContainer(keyedBy: PokemonKeys.MovesDictionaryKeys.self)
            let movesKeys = try movesDictionary.nestedContainer(keyedBy: PokemonKeys.MovesDictionaryKeys.MoveKeys.self, forKey: .move)
            
            let moves = try movesKeys.decode(String.self, forKey: .name)
            
            movesList.append(moves)
        }
        
        moves = movesList
        
        var typesList: [String] = []
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        
        while !typesContainer.isAtEnd {
            let typesDictionary = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypesDictionaryKeys.self)
            
            let typeKeys = try typesDictionary.nestedContainer(keyedBy: PokemonKeys.TypesDictionaryKeys.TypeKeys.self, forKey: .type)
            
            let type = try typeKeys.decode(String.self, forKey: .name)
            typesList.append(type)
        }
        types = typesList
    }
}

