//
//  FavoritesView.swift
//  PoketDex
//
//  Created by Aman Giri on 2024-04-20.
//

import SwiftUI

struct FavoritesView: View {
    
    @StateObject var pokemonVM = PokemonViewModel(fetcher: PokemonFetcher())
    @State var favoritePokemon: [Pokemon] = []
    
    @State var favoriteCount = 0
    
    var body: some View {
        VStack{
            if favoriteCount == 0 {
                VStack{
                    Text("No pokemon added to favorites")
                        .foregroundStyle(.secondary)
                }
                
            } else {
                Text("Favorite List")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top,10)
                List(favoritePokemon, id: \.self){pokemon in
                    NavigationLink(value:pokemon){
                        HStack{
                            AsyncImage(url: pokemon.sprite) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 80, height: 80)
                            
                            Text("\(pokemon.name!.capitalized)")
                                .font(.title3)
                                .fontWeight(.regular)
                                .padding(.leading,30)
                        }
                        
                    }
                }
                .navigationDestination(for: Pokemon.self) { pokemon in
                    PokemonDetailView()
                        .environmentObject(pokemon)
                }
            }
                
        }
        .onAppear{
            favoritePokemon = pokemonVM.getAllFavoritePokemon()
            favoriteCount = favoritePokemon.count
        }
    }
}

#Preview {
    ContentView()
}
