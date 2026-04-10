//
//  HomeView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/18/25.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var dataHolder: DataHolder
    
    @EnvironmentObject var authManager: AuthManager
    
    enum Tab { case home, scan, profile}
    
    @State private var selected: Tab = .home
    @State private var isSearching: Bool = false
    @State private var query: String = ""
    @FocusState private var searchFocused: Bool
    

    var body: some View {
        ZStack {
            Group {
                switch selected {
                    
                case .home:
                    NavigationStack {
                        VStack(spacing: 15) {
                            Text("Welcome \(authManager.currentUser?.displayName ?? "User")")
                                .font(.system(size: 17, weight: .semibold, design: .serif))
                                .background(Color(.systemBackground))
                            
                            Text("Please select the company:")
                                .font(.system(size: 17, design: .serif))
                                .background(Color(.systemBackground))
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 30)
                        .onAppear {
                            authManager.fetchCurrentAppUser { _ in }
                            

                        }
                        
                        CompanyView()
                            .environmentObject(authManager)
                            .environmentObject(dataHolder)
                    }
                    
                case .scan:
                    ScanView()
                    
                    
                case .profile:
                    ProfileView()
                    
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            
            
            VStack{
                Spacer()
                HStackLayout(spacing: 20){
                    Spacer()
                    
                    TabButton(title: "Home", system: "building.2.fill", active: selected == .home) {
                        withAnimation(.easeInOut) {
                            selected = .home
                        }
                    }
                    
                    TabButton(title: "Scan", system: "qrcode.viewfinder", active: selected == .scan) {
                        withAnimation(.easeInOut) {
                            selected = .scan
                        }
                    }
                    
                
                    TabButton(title: "Profile", system: "person.crop.circle", active: selected == .profile) {
                        withAnimation(.easeInOut) {
                            selected = .profile
                        }
                    }
                    
        
                    Spacer()
                    
                }
                

                .background(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: 8)
                
            }
            
        }
    }
}


struct TabButton: View {
    let title: String
    let system: String
    let active: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4){
                Image(systemName: system)
                    .font(.system(size: 18, weight: .semibold))
                
                Text(title)
                    .font(.system(size: 10, weight: .bold, design: .serif))
            }
            .foregroundStyle(active ? .blue : .secondary)
            .frame(width: 72)
            .padding(.vertical, 2)
        }.buttonStyle(.plain)
    }
}
