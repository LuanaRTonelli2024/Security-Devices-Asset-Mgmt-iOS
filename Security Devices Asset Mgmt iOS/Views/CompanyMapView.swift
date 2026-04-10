//
//  CompanyMapView.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by Jimena Marin on 2026-03-27.
//

import SwiftUI
import MapKit



struct CompanyMapView: View {
    
    @StateObject private var CompanyMVM: CompanyMapViewModel
    
    init(company: CompanyEntity) { //to recive company as a param for the ViewM
        _CompanyMVM = //to acces the StateObj
        StateObject(wrappedValue: CompanyMapViewModel(company: company))//Create the StateObj with the param
    }
    
    var body: some View {
        ZStack {
            Map(position: $CompanyMVM.camera) {
                if let userLocation = CompanyMVM.locationManager.userLocation {
                    Marker("You", coordinate: userLocation)
                        .tint(.blue)
                }
                if let destination = CompanyMVM.destination {
                    Marker(CompanyMVM.company.name ?? "", coordinate: destination)
                        .tint(.red)
                }
                if let route = CompanyMVM.route {
                    MapPolyline(route.polyline)
                        .stroke(.blue, lineWidth: 4)
                }
            }
            .mapStyle(.hybrid(elevation: .realistic))
            .onMapCameraChange { context in
                CompanyMVM.currentCenter = context.region.center
            }
            
            VStack {
                HStack {
                    Spacer()
                    VStack(spacing: 10) {
                        Button(action: CompanyMVM.goToUserLocation) {
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
                        Button(action: CompanyMVM.zoomIn) {
                            Image(systemName: "plus.magnifyingglass")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }.shadow(radius: 4)
                        
                        Button(action: CompanyMVM.zoomOut) {
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
                
                Picker("Transport", selection: $CompanyMVM.transportType) {
                    Text("Automobile").tag(MKDirectionsTransportType.automobile)
                        .font(.system(size: 14, design: .serif))
                    Text("Transit").tag(MKDirectionsTransportType.transit)
                        .font(.system(size: 14, design: .serif))
                    Text("Walking").tag(MKDirectionsTransportType.walking)
                        .font(.system(size: 14, design: .serif))
                    
                }
                .pickerStyle(.segmented)
                .onChange(of: CompanyMVM.transportType) { _ in
                    Task { @MainActor in
                        await CompanyMVM.ShowRoute()
                    }
                }
                
                if CompanyMVM.isLoading {
                    ProgressView("Calculating route...")
                        .font(.system(size: 14, design: .serif))
                        .tint(.white)
                        .frame(width: 24, height: 24)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 14)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                if let errorMessage = CompanyMVM.errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 13, design: .serif))
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .padding(.bottom, 60)
            .background(.thinMaterial)
        }
        .navigationTitle(CompanyMVM.company.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(CompanyMVM.locationManager.$userLocation) { newValue in
            guard !CompanyMVM.didAutoCenter, let loc = newValue else { return }
            CompanyMVM.didAutoCenter = true
            CompanyMVM.camera = .camera(MapCamera(centerCoordinate: loc, distance: CompanyMVM.zoomLevel))
            Task { @MainActor in
                await CompanyMVM.ShowRoute()
            }
        }
    }
}
