//
//  ContentView.swift
//  Pawgress
//
//  Created by Emily on 2025/4/16.
//
import SwiftUI

struct ContentView: View {

    var body: some View {
        
        Image("rabbits")
            .resizable()
            .cornerRadius(20.0)
            .aspectRatio(contentMode: .fit)
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
        Text("Welcome to Pawgress!")

    }
}

#Preview {
    ContentView()
}
