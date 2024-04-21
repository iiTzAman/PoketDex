//
//  ContentView.swift
//  PoketDex
//
//  Created by Aman Giri on 2024-04-15.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    var body: some View {
        GeometryReader{ geo in
            TabView{
                NavigationStack {
                    ScrollView{
                        PokemonListView()
                    }
                }
                .padding()
                .tabItem {
                    Label("Pokedex", systemImage: "house")
                }
                NavigationStack{
                    FavoritesView()
                }
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
            }
            .preferredColorScheme(.light)
            .accentColor(.black)
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
