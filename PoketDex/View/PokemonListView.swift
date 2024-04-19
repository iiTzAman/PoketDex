//
//  PokemonListView.swift
//  PoketDex
//
//  Created by Aman Giri on 2024-04-16.
//

import SwiftUI

struct PokemonListView: View {
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default
    ) private var pokedex: FetchedResults<Pokemon>
    
    @State var searchText: String = ""
    
    @StateObject var pokemonVM = PokemonViewModel(fetcher: PokemonFetcher())
    
    var filteredPokemon : [Pokemon] {
        return pokemonVM.filterSearch(searchText: searchText)!
    }
    
    var body: some View {
            LazyVGrid(columns: [GridItem(),GridItem(), GridItem()], content: {
                ForEach(filteredPokemon){ pokemon in
                    NavigationLink(value: pokemon){
                        ZStack(alignment:.bottom){
                            AsyncImage(url: pokemon.icon) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .padding(.bottom)
                            Text("\(pokemon.name!.capitalized)")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(width: 80, height: 80)
                    .padding()
                    .overlay(RoundedRectangle.rect(cornerRadius: 20).stroke(lineWidth: 0.5))
                }
            })
            .padding(.top)
            .navigationTitle("Pokedex")
            .searchable(text: $searchText)
            .navigationDestination(for: Pokemon.self) { pokemon in
                PokemonDetailView()
                    .environmentObject(pokemon)
            }
        }
}

#Preview {
    PokemonListView(searchText: "", pokemonVM: PokemonViewModel(fetcher: PokemonFetcher()))
}
