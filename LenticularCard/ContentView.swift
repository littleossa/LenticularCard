//
//  ContentView.swift
//  LenticularCard
//
//  Created by 平岡修 on 2022/03/30.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var lenticulationManager = LenticulationManager()

    var body: some View {
        ZStack {
            Image("back")
                .resizable()
                .ignoresSafeArea()
            Image("middle")
                .resizable()
                .ignoresSafeArea()
                .opacity(lenticulationManager.middleImageOpacity)
            Image("front")
                .resizable()
                .ignoresSafeArea()
                .opacity(lenticulationManager.frontImageOpacitry)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
