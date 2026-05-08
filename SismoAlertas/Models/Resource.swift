import UIKit

struct Resource: Codable, Identifiable, Sendable {
    let id: UUID
    var nombre: String
    var cantidad: Int
    var minimoRequerido: Int

    init(
        id: UUID = UUID(),
        nombre: String,
        cantidad: Int,
        minimoRequerido: Int = 5
    ) {
        self.id = id
        self.nombre = nombre
        self.cantidad = cantidad
        self.minimoRequerido = minimoRequerido
    }

    var esCritico: Bool {
        cantidad < minimoRequerido
    }

    var color: UIColor {
        if cantidad == 0 { return .systemRed }
        if esCritico { return .systemOrange }
        return .systemGreen
    }

    var icon: String {
        if cantidad == 0 { return "xmark.circle.fill" }
        if esCritico { return "exclamationmark.triangle.fill" }
        return "checkmark.circle.fill"
    }
}
