import UIKit

enum FamilyStatus: String, Codable, CaseIterable, Sendable {
    case bien = "Bien"
    case necesitaRevision = "Necesita Revisión"
    case urgente = "Urgente"
    case noLocalizado = "No Localizado"

    var color: UIColor {
        switch self {
        case .bien: return .systemGreen
        case .necesitaRevision: return .systemOrange
        case .urgente: return .systemRed
        case .noLocalizado: return .systemGray
        }
    }

    var icon: String {
        switch self {
        case .bien: return "checkmark.circle.fill"
        case .necesitaRevision: return "exclamationmark.triangle.fill"
        case .urgente: return "xmark.octagon.fill"
        case .noLocalizado: return "questionmark.circle.fill"
        }
    }
}
