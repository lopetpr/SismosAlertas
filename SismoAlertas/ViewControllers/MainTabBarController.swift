import UIKit
import SwiftUI

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }

    private func setupTabs() {
        // Tab 1: Resumen (SwiftUI — bonus)
        let resumenVC = UIHostingController(rootView: ResumenView())
        resumenVC.tabBarItem = UITabBarItem(
            title: "Resumen",
            image: UIImage(systemName: "chart.bar.fill"),
            tag: 0
        )

        // Tab 2: Familias (UIKit + Push navigation)
        let familiasNav = UINavigationController(rootViewController: FamiliasViewController())
        familiasNav.tabBarItem = UITabBarItem(
            title: "Familias",
            image: UIImage(systemName: "person.3.fill"),
            tag: 1
        )

        // Tab 3: Tareas (UIKit + filtro)
        let tareasNav = UINavigationController(rootViewController: TareasViewController())
        tareasNav.tabBarItem = UITabBarItem(
            title: "Tareas",
            image: UIImage(systemName: "checklist"),
            tag: 2
        )

        // Tab 4: Recursos (UIKit)
        let recursosNav = UINavigationController(rootViewController: RecursosViewController())
        recursosNav.tabBarItem = UITabBarItem(
            title: "Recursos",
            image: UIImage(systemName: "shippingbox.fill"),
            tag: 3
        )

        viewControllers = [resumenVC, familiasNav, tareasNav, recursosNav]
    }

    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .systemRed
    }
}
