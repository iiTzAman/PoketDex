//
//  PokemonDetailView.swift
//  PoketDex
//
//  Created by Aman Giri on 2024-04-16.
//

import SwiftUI
import Charts

struct PokemonDetailView: View {
    @EnvironmentObject var pokemon: Pokemon
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ScrollView{
            ZStack {
                Color(.skyblue)
                    .offset(y: -10)
                    .frame(height: 360)
                AsyncImage(url: pokemon.sprite) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 300, height: 300)
                .onTapGesture {
                    SoundManager.instance.playSound(for: Int(pokemon.id))
                }
                .offset(y: 55)

                
            }
            
            VStack {
                HStack{
                    Text("\(pokemon.name!.capitalized)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    
                    Button{
                        pokemon.favorite.toggle()
                        do{
                            try viewContext.save()
                        }catch{
                            print(error)
                        }
                        
                    } label: {
                        Image(systemName: pokemon.favorite ? "star.fill" : "star")
                            .padding(.trailing)
                            .font(.largeTitle)
                            .foregroundStyle(.yellow)
                    }
                    
                    
                }
                .padding([.top, .leading, .trailing],20)
                HStack {
                    Text("Weight: \(pokemon.weight)")
                        .padding(.horizontal)
                    Text("Height: \(pokemon.height)")
                    Spacer()
                }
                .padding(.top, 5)
                .padding(.leading, 5)
            }

            HStack{
                ForEach(pokemon.types!, id:\.self){ type in
                    Text("\(type.capitalized)")
                        .padding()
                        .padding(.horizontal)
                        .background(Color(type.capitalized))
                        .foregroundStyle(.black)
                        .fontWeight(.medium)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                }
                Spacer()
            }
            .padding([.top, .leading],20)
            Divider()
                .padding(.top, 25)
            HStack {
                Text("Stats")
                    .padding(.top,20)
                    .font(.title)
                .fontWeight(.bold)
                Spacer()
            }
            .padding(.leading, 20)
            
            
            
            Chart(pokemon.stats) { stat in
                BarMark(x: .value("value", stat.value), y: .value("stats", stat.name.capitalized))
                    .annotation(position: .trailing, alignment: .center) {
                        Text("\(stat.value)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
            }
            .frame(height: 250)
            .foregroundStyle(Color(pokemon.types![0].capitalized))
            .chartXScale(domain: 0...pokemon.highestStat.value+10)
            .padding([.leading,.trailing,.bottom])
        }
        .ignoresSafeArea()
        .padding(.bottom)

    }
}

#Preview {
    PokemonDetailView()
        .environmentObject(ShowPreviewData.samplePokemon)
}
