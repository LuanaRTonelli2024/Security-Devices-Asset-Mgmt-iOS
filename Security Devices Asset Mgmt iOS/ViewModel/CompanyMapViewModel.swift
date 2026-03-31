//
//  CompanyMapViewModel.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by Jimena Marin on 2026-03-30.
//

import Foundation
import MapKit
import SwiftUI

extension MKDirectionsTransportType: Hashable {}

@MainActor
class CompanyMapViewModel: ObservableObject {
    
    @Published var camera: MapCameraPosition = .automatic
    
    @Published var destination: CLLocationCoordinate2D?
    @Published var route: MKRoute?
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var transportType: MKDirectionsTransportType = .automobile
    
    var zoomLevel: Double = 3000
    var didAutoCenter: Bool = false
    var currentCenter: CLLocationCoordinate2D?
    
    var locationManager = LocationManager()
    var company: CompanyEntity
    
    init(company: CompanyEntity) {
        self.company = company
    }
    
    
    
    //MARK: map action buttons
    func goToUserLocation() {
        guard let userLocation = locationManager.userLocation else { return }
        camera = .camera(MapCamera(centerCoordinate: userLocation, distance: zoomLevel))
    }
    
    func zoomIn() {
        guard let center = currentCenter else { return }
        zoomLevel *= 0.8
        camera = .camera(MapCamera(centerCoordinate: center, distance: zoomLevel))
    }
    
    func zoomOut() {
        guard let center = currentCenter else { return }
        zoomLevel *= 1.2
        camera = .camera(MapCamera(centerCoordinate: center, distance: zoomLevel))
    }
    
    
    //MARK: Destination and route
    //adress string into lat,lon
    func getGeoLocation(_ address: String) async throws ->
    CLLocationCoordinate2D {
        try await withCheckedThrowingContinuation { continuation in
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = address
            
            MKLocalSearch(request: request).start { response, error in
                if let error { continuation.resume(throwing: error); return }
                guard let coordinate = response?.mapItems.first?.placemark.coordinate else {
                    continuation.resume(throwing: NSError(
                        domain: "Coordinates", code: 0,
                        userInfo: [NSLocalizedDescriptionKey: "Address not found"]))
                    return
                }
                continuation.resume(returning: coordinate)
            }
        }
    }
    
    func geocodeCompanyAddress() async { //to get the geoLocation for CEV
        guard let address = company.address, !address.isEmpty else { return }
        destination = try? await getGeoLocation(address)
    }
    
    func calculateRoute(from source: CLLocationCoordinate2D,
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
    
    func ShowRoute() async {
        guard let userLocation = locationManager.userLocation,
              let address = company.address, !address.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let dest = try await getGeoLocation(address)
            destination = dest
            
            let routeToDest = try await calculateRoute(from: userLocation, to: dest, transport: transportType)
            route = routeToDest
            
            let rect = routeToDest.polyline.boundingMapRect
            camera = .region(MKCoordinateRegion(rect))
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
