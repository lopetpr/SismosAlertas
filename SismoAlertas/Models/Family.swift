import Foundation

struct Family: Codable, Identifiable, Sendable {
    let id: UUID
    var nombre: String
    var direccion: String
    var integrantes: Int
    var necesidadesEspeciales: String
    var estado: FamilyStatus
    var notas: String

    init(
        id: UUID = UUID(),
        nombre: String,
        direccion: String,
        integrantes: Int,
        necesidadesEspeciales: String = "",
        estado: FamilyStatus = .noLocalizado,
        notas: String = ""
    ) {
        self.id = id
        self.nombre = nombre
        self.direccion = direccion
        self.integrantes = integrantes
        self.necesidadesEspeciales = necesidadesEspeciales
        self.estado = estado
        self.notas = notas
    }
}
