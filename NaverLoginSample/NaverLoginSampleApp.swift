//
//  NaverLoginSampleApp.swift
//  NaverLoginSample
//
//  Created by Ethan Parker on 10/31/23.
//

import SwiftUI

@main
struct NaverLoginSampleApp: App {
    
    init() {
        NaverLogin.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
