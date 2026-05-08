import UIKit

enum TaskStatus: String, Codable, CaseIterable, Sendable {
    case pendiente = "Pendiente"
    case enCurso = "En Curso"
    case completada = "Completada"

    var color: UIColor {
        switch self {
        case .pendiente: return .systemRed
        case .enCurso: return .systemBlue
        case .completada: return .systemGreen
        }
    }

    var icon: String {
        switch self {
        case .pendiente: return "clock.fill"
        case .enCurso: return "arrow.triangle.2.circlepath"
        case .completada: return "checkmark.seal.fill"
        }
    }
}
