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
    
    @StateObject var pokemonVM = PokemonViewModel(fetcher: PokemonFetcher())
    
    var body: some View {
        GeometryReader{ geo in
            NavigationStack {
                ScrollView{
                    PokemonListView()
                }
            }
            .padding()
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
