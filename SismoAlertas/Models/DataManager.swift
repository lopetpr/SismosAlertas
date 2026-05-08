import Foundation

final class DataManager {
    static let shared = DataManager()

    private let familiasKey = "sismoalertas_familias"
    private let tareasKey = "sismoalertas_tareas"
    private let recursosKey = "sismoalertas_recursos"

    private(set) var familias: [Family] = []
    private(set) var tareas: [BrigadeTask] = []
    private(set) var recursos: [Resource] = []

    // Notification names for KVO-free updates
    static let dataDidChangeNotification = Notification.Name("DataManagerDataDidChange")

    private init() {
        loadAll()
        if familias.isEmpty && tareas.isEmpty && recursos.isEmpty {
            loadSampleData()
        }
    }

    // MARK: - Persistence

    private func loadAll() {
        familias = load(key: familiasKey) ?? []
        tareas = load(key: tareasKey) ?? []
        recursos = load(key: recursosKey) ?? []
    }

    private func load<T: Decodable>(key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    private func save<T: Encodable>(_ value: T, key: String) {
        if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func notifyChange() {
        NotificationCenter.default.post(name: Self.dataDidChangeNotification, object: nil)
    }

    // MARK: - Familias CRUD

    func addFamily(_ family: Family) {
        familias.append(family)
        save(familias, key: familiasKey)
        notifyChange()
    }

    func updateFamily(_ family: Family) {
        if let index = familias.firstIndex(where: { $0.id == family.id }) {
            familias[index] = family
            save(familias, key: familiasKey)
            notifyChange()
        }
    }

    func deleteFamily(at index: Int) {
        familias.remove(at: index)
        save(familias, key: familiasKey)
        notifyChange()
    }

    // MARK: - Tareas CRUD

    func addTask(_ task: BrigadeTask) {
        tareas.append(task)
        save(tareas, key: tareasKey)
        notifyChange()
    }

    func updateTask(_ task: BrigadeTask) {
        if let index = tareas.firstIndex(where: { $0.id == task.id }) {
            tareas[index] = task
            save(tareas, key: tareasKey)
            notifyChange()
        }
    }

    func deleteTask(at index: Int) {
        tareas.remove(at: index)
        save(tareas, key: tareasKey)
        notifyChange()
    }

    // MARK: - Recursos CRUD

    func addResource(_ resource: Resource) {
        recursos.append(resource)
        save(recursos, key: recursosKey)
        notifyChange()
    }

    func updateResource(_ resource: Resource) {
        if let index = recursos.firstIndex(where: { $0.id == resource.id }) {
            recursos[index] = resource
            save(recursos, key: recursosKey)
            notifyChange()
        }
    }

    func deleteResource(at index: Int) {
        recursos.remove(at: index)
        save(recursos, key: recursosKey)
        notifyChange()
    }

    // MARK: - Computed Stats

    func familyCount(for status: FamilyStatus) -> Int {
        familias.filter { $0.estado == status }.count
    }

    var pendingTaskCount: Int {
        tareas.filter { $0.estado == .pendiente }.count
    }

    var criticalResourceCount: Int {
        recursos.filter { $0.esCritico }.count
    }

    // MARK: - Sample Data

    private func loadSampleData() {
        familias = [
            Family(nombre: "Familia García", direccion: "Av. Arequipa 1234", integrantes: 4, necesidadesEspeciales: "Adulto mayor con movilidad reducida", estado: .bien, notas: "Contacto verificado"),
            Family(nombre: "Familia López", direccion: "Jr. Cusco 567", integrantes: 3, necesidadesEspeciales: "Niño con asma", estado: .necesitaRevision, notas: "Pendiente revisión médica"),
            Family(nombre: "Familia Torres", direccion: "Calle Lima 890", integrantes: 5, necesidadesEspeciales: "", estado: .urgente, notas: "Estructura dañada, necesitan reubicación"),
            Family(nombre: "Familia Quispe", direccion: "Av. Brasil 321", integrantes: 2, necesidadesEspeciales: "Embarazada 7 meses", estado: .noLocalizado, notas: "Sin contacto desde sismo"),
            Family(nombre: "Familia Mendoza", direccion: "Jr. Huancavelica 456", integrantes: 6, necesidadesEspeciales: "2 niños menores de 3 años", estado: .bien, notas: ""),
            Family(nombre: "Familia Rodríguez", direccion: "Calle Tacna 789", integrantes: 3, necesidadesEspeciales: "", estado: .necesitaRevision, notas: "Reportan grietas en paredes")
        ]

        tareas = [
            BrigadeTask(titulo: "Evaluar estructura Familia Torres", descripcion: "Inspeccionar daño estructural y determinar si es habitable", estado: .pendiente, responsable: "Brigada Alpha"),
            BrigadeTask(titulo: "Entregar kit médico Familia López", descripcion: "Kit incluye inhalador y medicamentos básicos", estado: .enCurso, responsable: "Brigada Beta"),
            BrigadeTask(titulo: "Localizar Familia Quispe", descripcion: "Última ubicación conocida: Av. Brasil 321, verificar con vecinos", estado: .pendiente, responsable: "Brigada Alpha"),
            BrigadeTask(titulo: "Repartir agua zona norte", descripcion: "Distribuir 50L de agua potable en zona afectada norte", estado: .completada, responsable: "Brigada Gamma"),
            BrigadeTask(titulo: "Instalar carpa temporal", descripcion: "Carpa para 8 personas en punto de reunión sector 3", estado: .enCurso, responsable: "Brigada Delta"),
            BrigadeTask(titulo: "Revisar grietas Familia Rodríguez", descripcion: "Evaluar severidad de grietas reportadas", estado: .pendiente, responsable: "Brigada Beta")
        ]

        recursos = [
            Resource(nombre: "Agua (litros)", cantidad: 120, minimoRequerido: 200),
            Resource(nombre: "Botiquín primeros auxilios", cantidad: 8, minimoRequerido: 10),
            Resource(nombre: "Generador eléctrico", cantidad: 2, minimoRequerido: 3),
            Resource(nombre: "Radio comunicación", cantidad: 5, minimoRequerido: 4),
            Resource(nombre: "Carpas", cantidad: 3, minimoRequerido: 5),
            Resource(nombre: "Linternas", cantidad: 15, minimoRequerido: 10),
            Resource(nombre: "Frazadas", cantidad: 25, minimoRequerido: 30),
            Resource(nombre: "Alimento enlatado (unidades)", cantidad: 45, minimoRequerido: 100)
        ]

        save(familias, key: familiasKey)
        save(tareas, key: tareasKey)
        save(recursos, key: recursosKey)
    }
}
