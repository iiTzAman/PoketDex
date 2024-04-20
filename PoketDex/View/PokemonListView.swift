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
    @State var filterOn = false
    @State var currentType = "all"
    
    @StateObject var pokemonVM = PokemonViewModel(fetcher: PokemonFetcher())
    
    var filteredPokemon : [Pokemon] {
        if !filterOn {
            pokemonVM.filterByType(type: "all")
            pokemonVM.pokeDex = pokemonVM.filterSearch(searchText: searchText)
            return pokemonVM.pokeDex
        } else {
            pokemonVM.filterByType(type: currentType)
            pokemonVM.pokeDex = pokemonVM.filterSearch(searchText: searchText)
            return pokemonVM.pokeDex
        }
    }
    
    
    var body: some View {
        VStack {
            if filterOn {
                FilterView(currentType: $currentType, filterOn: $filterOn)
            }
            VStack {
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
                .navigationTitle("Pokedex")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchText)
                .navigationDestination(for: Pokemon.self) { pokemon in
                    PokemonDetailView()
                        .environmentObject(pokemon)
                }
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button{
                            withAnimation{
                                filterOn.toggle()
                            }
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .tint(filterOn ? .pink : .black)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}


