// ContentView.swift — Not used. App uses MainTabBarController via SismoAlertasApp.swift
// Kept for Xcode file sync compatibility.

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabBarRepresentable()
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
