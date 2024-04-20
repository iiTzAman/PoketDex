//
//  FilterView.swift
//  PoketDex
//
//  Created by Aman Giri on 2024-04-19.
//

import Foundation
import SwiftUI

struct FilterView: View {
    @StateObject var pokemonVM = PokemonViewModel(fetcher: PokemonFetcher())
    
    var allTypes: [String] {
        return pokemonVM.getAllTypes()
    }
    
    @State var isSelected = false
    @Binding var currentType: String
    @Binding var filterOn: Bool
    
    var body: some View {
        HStack{
            VStack{
                Divider()
                    .padding(.vertical,10)
                HStack{
                    Text("Filters")
                        .fontWeight(.bold)
                    Spacer()
                    Button{
                        withAnimation{ 
                            filterOn.toggle()
                            currentType = "all"
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .padding(.trailing,15)
                            .foregroundStyle(.black)
                    }
                    
                }
                .padding(.bottom,10)
                
                .padding(.leading,10)
                LazyVGrid(columns: [GridItem(),GridItem(),GridItem(), GridItem()], content: {
                    ForEach(allTypes, id: \.self){ type in
                        Button{
                            withAnimation{
                                currentType = type
                            }
                        }label: {
                            if self.currentType == type {
                                
                                Text("\(type.capitalized)")
                                    .font(.caption)
                                    .padding(5)
                                    .foregroundStyle(.white)
                                    .frame(width: 70)
                                    .background(.pink)
                                    .overlay(RoundedRectangle(cornerRadius: 5).stroke().fill(.gray))
                                    .clipShape(.rect(cornerRadius: 10))
                            } else {
                                Text("\(type.capitalized)")
                                    .font(.caption)
                                    .padding(5)
                                    .foregroundStyle(.gray)
                                    .frame(width: 70)
                                    .background(.white)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke().fill(.gray))

                            }
                        }
                        
                    }
                })
                Divider()
                    .padding(.vertical,10)
            }
            
        }
    }
}

#Preview {
    ContentView()
}
