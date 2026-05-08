import Foundation

struct BrigadeTask: Codable, Identifiable, Sendable {
    let id: UUID
    var titulo: String
    var descripcion: String
    var estado: TaskStatus
    var fechaCreacion: Date
    var responsable: String

    init(
        id: UUID = UUID(),
        titulo: String,
        descripcion: String,
        estado: TaskStatus = .pendiente,
        fechaCreacion: Date = Date(),
        responsable: String = ""
    ) {
        self.id = id
        self.titulo = titulo
        self.descripcion = descripcion
        self.estado = estado
        self.fechaCreacion = fechaCreacion
        self.responsable = responsable
    }
}
