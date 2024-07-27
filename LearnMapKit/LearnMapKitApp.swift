//
//  LearnMapKitApp.swift
//  LearnMapKit
//
//  Created by hs on 7/26/24.
//

import SwiftUI
import CoreLocation

@main
struct LearnMapKitApp: App {
    @StateObject var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    locationManager.requestAuthorization()
                }
                .environmentObject(locationManager)
        }
    }
}
