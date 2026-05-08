//
//  SismoAlertasApp.swift
//  SismoAlertas
//
//  Created by huber lope on 8/05/26.
//

import SwiftUI
import UIKit

@main
struct SismoAlertasApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabBarRepresentable()
                .ignoresSafeArea()
        }
    }
}

// Bridge UIKit TabBarController into SwiftUI App lifecycle
struct MainTabBarRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainTabBarController {
        MainTabBarController()
    }

    func updateUIViewController(_ uiViewController: MainTabBarController, context: Context) {}
}
