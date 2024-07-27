//
//  LocationManager.swift
//  LearnMapKit
//
//  Created by hs on 7/27/24.
//

import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var isAuthorized: Bool = false
    
    override init() {
        super.init()
        self.manager.delegate = self
    }
    
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        updateAuthorizationStatus()
    }
    
    private func updateAuthorizationStatus() {
        let status = manager.authorizationStatus
        isAuthorized = (status == .authorizedWhenInUse || status == .authorizedAlways)
    }
}
