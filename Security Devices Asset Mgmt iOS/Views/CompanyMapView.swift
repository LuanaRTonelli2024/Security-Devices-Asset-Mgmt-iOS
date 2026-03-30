//
//  CompanyMapView.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by Jimena Marin on 2026-03-27.
//

import SwiftUI
import MapKit

extension MKDirectionsTransportType: Hashable {}

struct CompanyMapView: View {
    
    @StateObject private var locationManager = LocationManager()
    @State private var camera: MapCameraPosition = .automatic
    @State private var zoomLevel: Double = 3000
    
    @State private var destination: CLLocationCoordinate2D?
    @State private var route: MKRoute?
    
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    @State private var didAutoCenter: Bool = false
    @State private var currentCenter: CLLocationCoordinate2D?
    
    @State private var transportType: MKDirectionsTransportType = .automobile
    
    let company: Company
    
    var body: some View {
        ZStack {
            Map(position: $camera) {
                if let userLocation = locationManager.userLocation {
                    Marker("You", coordinate: userLocation)
                        .tint(.blue)
                }
                if let destination {
                    Marker(company.name, coordinate: destination)
                        .tint(.red)
                }
                if let route {
                    MapPolyline(route.polyline)
                        .stroke(.blue, lineWidth: 4)
                }
            }
            .mapStyle(.standard)
            .onMapCameraChange { context in
                currentCenter = context.region.center
            }
            
            VStack {
                HStack {
                    Spacer()
                    VStack(spacing: 10) {
                        Button(action: goToUserLocation) {
                            Image(systemName: "location.fill")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        .shadow(radius: 4)
                    }
                    .padding()
                }
                Spacer()
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack(spacing: 10) {
                        Button(action: zoomIn) {
                            Image(systemName: "plus.magnifyingglass")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }.shadow(radius: 4)
                        
                        Button(action: zoomOut) {
                            Image(systemName: "minus.magnifyingglass")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }.shadow(radius: 4)
                    }
                    .padding()
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 10) {
                
                Picker("Transport", selection: $transportType) {
                    Text("Automobile").tag(MKDirectionsTransportType.automobile)
                    Text("Transit").tag(MKDirectionsTransportType.transit)
                    Text("Walking").tag(MKDirectionsTransportType.walking)
                    Text("Cycling").tag(MKDirectionsTransportType.cycling)
                }
                .pickerStyle(.segmented)
                .onChange(of: transportType) { _ in
                    Task { @MainActor in
                        //await calculateAndShowRoute()
                    }
                }
                
                if isLoading {
                    ProgressView("Calculating route...")
                        .tint(.white)
                        .frame(width: 24, height: 24)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 14)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                if let errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .background(.thinMaterial)
        }
        .navigationTitle(company.name)
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(locationManager.$userLocation) { newValue in
            guard !didAutoCenter, let loc = newValue else { return }
            didAutoCenter = true
            camera = .camera(MapCamera(centerCoordinate: loc, distance: zoomLevel))
            Task { @MainActor in
                //await calculateAndShowRoute()
            }
        }
        
    }
    
    //MARK: map action buttons
    private func goToUserLocation() {
            guard let userLocation = locationManager.userLocation else { return }
            withAnimation {
                camera = .camera(MapCamera(centerCoordinate: userLocation, distance: zoomLevel))
            }
        }
    
    private func zoomIn(){
        guard let center = currentCenter else { return }
        withAnimation{
            zoomLevel *= 0.8
            camera = .camera(MapCamera(centerCoordinate: center, distance: zoomLevel))
        }
    }
    
    private func zoomOut(){
        guard let center = currentCenter else { return }
        withAnimation{
            zoomLevel *= 1.2
            camera = .camera(MapCamera(centerCoordinate: center, distance: zoomLevel))
        }
    }
    
    
    //MARK: Destination and route
    //adress string into lat,lon
    private func getGeoLocation(_ address: String) async throws ->
    CLLocationCoordinate2D {
            try await withCheckedThrowingContinuation { continuation in
                CLGeocoder().geocodeAddressString(address) { placemarks, error in
                    if let error { continuation.resume(throwing: error); return }
                    guard let coordinate = placemarks?.first?.location?.coordinate else {
                        continuation.resume(throwing: NSError(
                            domain: "Coordinates", code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "Address not found"]))
                        return
                    }
                    continuation.resume(returning: coordinate)
                }
            }
        }
    
    
    private func calculateRoute(from source: CLLocationCoordinate2D,
                                to destination: CLLocationCoordinate2D,
                                transport: MKDirectionsTransportType) async throws -> MKRoute {
        try await withCheckedThrowingContinuation { continuation in
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
            request.transportType = transport
            
            MKDirections(request: request).calculate { response, error in
                if let error { continuation.resume(throwing: error); return }
                guard let route = response?.routes.first else {
                    continuation.resume(throwing: NSError(
                        domain: "Directions", code: 0,
                        userInfo: [NSLocalizedDescriptionKey: "No route found"]))
                    return
                }
                continuation.resume(returning: route)
            }
        }
    }
}
