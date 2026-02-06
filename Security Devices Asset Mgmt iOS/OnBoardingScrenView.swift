//
//  OnBoardingScrenView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/18/25.
//

import SwiftUI

struct OnBoardingScrenView: View {
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationView{
            VStack(spacing: 30){
                Spacer()
                Image("cctv")
                    .resizable()
                    .scaledToFill()
                    .padding()
                VStack(alignment: .center, spacing: 10){
                    Text("Security Devices")
                        .fontWeight(.bold)
                        .font(.system(.largeTitle))
                    Text("Asset Management")
                        .fontWeight(.bold)
                        .font(.system(.largeTitle))
                    Text("All the information you need is here!")
                        .font(.system(.title3))
                        .foregroundStyle(.black.opacity(0.7))
                }
                Spacer()
                NavigationLink(destination: LoginView().environmentObject(authManager)) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.blue)
                        .frame(width: 280, height: 60, alignment: .trailing)
                        .overlay {
                            HStack(spacing: 10) {
                                Text("Next")
                                    .font(.title)
                                    .fontWeight(.bold)
                                //Image(systemName: "chevron.right")
                            }.foregroundStyle(.black)
                        }
                }
                Spacer()
            }
            .navigationTitle("") // make it hidden
            .navigationBarHidden(true) // to make it hidden.
        }
        
    }
}

#Preview {
    OnBoardingScrenView()
}
