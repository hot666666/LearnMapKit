//
//  ContentView.swift
//  LearnMapKit
//
//  Created by hs on 7/26/24.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    static let hongikUniv = CLLocationCoordinate2D(latitude: 37.5563, longitude: 126.9231)
}

struct ContentView: View {
    @State private var position: MapCameraPosition = .automatic
    @State private var searchResults: [MKMapItem] = []
    @State private var selection: MKMapItem?
    @State private var lookAroundScene: MKLookAroundScene?
    @State private var visibleRegion: MKCoordinateRegion?
    
    var body: some View {
        ZStack {
            Map(position: $position, selection: $selection) {
                ForEach(searchResults, id: \.self) { place in
                    Marker(place.name ?? "", systemImage: "pc", coordinate: place.placemark.coordinate)
                }
            }
            .onMapCameraChange { context in
                visibleRegion = context.region
            }
            .onChange(of: selection) {
                if let selection = selection {
                    withAnimation {
                        position = .item(selection)
                    }
                }
                updateLookAroundScene(for: selection)
            }
            
            if let lookAroundScene = lookAroundScene {
                LookAroundPreview(scene: $lookAroundScene)
                    .frame(height: 200)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .offset(y: -10)
                    .padding()
            }
        }
        .safeAreaInset(edge: .bottom){
            PCButton(action: search)
        }
    }
    
    func search(for query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = MKCoordinateRegion(center: visibleRegion?.center ?? .hongikUniv, 
                                            span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))

        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
        }
    }
    
    func updateLookAroundScene(for mapItem: MKMapItem?) {
        guard let mapItem = mapItem else {
            lookAroundScene = nil
            return
        }
        
        Task {
            let request = MKLookAroundSceneRequest(mapItem: mapItem)
            do {
                lookAroundScene = try await request.scene
                if lookAroundScene == nil {
                    print("LookAround scene is not available for this location")
                }
            } catch {
                print("Error loading LookAround scene: \(error)")
            }
        }
    }
}

struct PCButton: View {
    var action: (String)->Void
    
    init(action: @escaping (String) -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action("pc방")
        }, label: {
            Image(systemName: "pc")
                .foregroundStyle(
                    LinearGradient(colors: [.red, .orange, .green, .blue, .purple],
                                   startPoint: .bottomLeading, endPoint: .topTrailing)
                )
                .font(.largeTitle)
        })
        .padding(5)
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 10))
    }
}


#Preview {
    ContentView()
}
