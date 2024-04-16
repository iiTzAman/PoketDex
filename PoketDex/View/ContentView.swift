//
//  ContentView.swift
//  PoketDex
//
//  Created by Aman Giri on 2024-04-15.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default
    ) private var pokedex: FetchedResults<Pokemon>
    
    @StateObject var pokemonVM = PokemonViewModel(fetcher: PokemonFetcher())
    
    var body: some View {
        GeometryReader{ geo in
            NavigationStack {
                ScrollView{
                    LazyVGrid(columns: [GridItem(),GridItem(), GridItem()], content: {
                        ForEach(pokedex){ pokemon in
                            NavigationLink(value: pokemon){
                                AsyncImage(url: pokemon.sprite) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            .frame(width: 50, height: 50)
                            .padding()
                            .overlay(RoundedRectangle.rect(cornerRadius: 20).stroke(lineWidth: 2))
                        }
                    })
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
