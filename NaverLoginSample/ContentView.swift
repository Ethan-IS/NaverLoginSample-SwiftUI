//
//  ContentView.swift
//  NaverLoginSample
//
//  Created by Ethan Parker on 10/31/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button(action: { NaverLogin.shared.login() }) {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("네이버 로그인")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
