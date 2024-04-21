//
//  PokemonListView.swift
//  PoketDex
//
//  Created by Aman Giri on 2024-04-16.
//

import SwiftUI

struct PokemonListView: View {
    
    @State var searchText: String = ""
    @State var filterOn = true
    @State var currentType = "all"
    
    @StateObject var pokemonVM = PokemonViewModel(fetcher: PokemonFetcher())
    
    
    var fetchingStatus: Bool {
        switch pokemonVM.status{
        case .fetching:
            return true
        default:
            return false
        }
    }
    
    
    var body: some View {
        VStack {
            if fetchingStatus{
                VStack{
                    Text("Fetching Pokemon data...")
                        .foregroundStyle(.secondary)
                    ProgressView()
                }
            }else{
                if filterOn {
                    FilterView(currentType: $currentType, filterOn: $filterOn)
                }
                ListView(filterOn: $filterOn, searchText: $searchText, currentType: $currentType)
            }
        }
    }
}

#Preview {
    ContentView()
}




