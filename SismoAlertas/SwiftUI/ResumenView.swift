import SwiftUI

struct ResumenView: View {
    @State private var familias: [Family] = DataManager.shared.familias
    @State private var tareas: [BrigadeTask] = DataManager.shared.tareas
    @State private var recursos: [Resource] = DataManager.shared.recursos
    @State private var animateCards = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    familyStatusGrid
                    tareasSection
                    recursosSection
                }
                .padding()
            }
            .navigationTitle("Resumen")
            .onAppear {
                refreshData()
                withAnimation(.easeOut(duration: 0.6)) {
                    animateCards = true
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: DataManager.dataDidChangeNotification)) { _ in
                refreshData()
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 4) {
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: 40))
                .foregroundStyle(.red)
                .symbolEffect(.pulse, isActive: animateCards)
            Text("SismoAlertas")
                .font(.title.bold())
            Text("Panel de Control — Brigada de Emergencia")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.bottom, 8)
    }

    // MARK: - Family Status Grid

    private var familyStatusGrid: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Estado de Familias", systemImage: "person.3.fill")
                .font(.headline)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(FamilyStatus.allCases, id: \.self) { status in
                    statusCard(for: status)
                }
            }
        }
    }

    private func statusCard(for status: FamilyStatus) -> some View {
        let count = familias.filter { $0.estado == status }.count
        return VStack(spacing: 8) {
            Image(systemName: status.icon)
                .font(.title2)
                .foregroundStyle(Color(status.color))

            Text("\(count)")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .contentTransition(.numericText())

            Text(status.rawValue)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(status.color).opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .scaleEffect(animateCards ? 1 : 0.8)
        .opacity(animateCards ? 1 : 0)
    }

    // MARK: - Tareas

    private var tareasSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Tareas Brigada", systemImage: "checklist")
                .font(.headline)

            HStack(spacing: 12) {
                tareaStatPill(
                    count: tareas.filter { $0.estado == .pendiente }.count,
                    label: "Pendientes",
                    color: .red
                )
                tareaStatPill(
                    count: tareas.filter { $0.estado == .enCurso }.count,
                    label: "En Curso",
                    color: .blue
                )
                tareaStatPill(
                    count: tareas.filter { $0.estado == .completada }.count,
                    label: "Completadas",
                    color: .green
                )
            }
        }
    }

    private func tareaStatPill(count: Int, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(color)
                .contentTransition(.numericText())
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Recursos

    private var recursosSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Recursos Críticos", systemImage: "shippingbox.fill")
                .font(.headline)

            let criticos = recursos.filter { $0.esCritico }

            if criticos.isEmpty {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("Todos los recursos sobre el mínimo")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                ForEach(criticos) { resource in
                    HStack {
                        Image(systemName: resource.icon)
                            .foregroundStyle(Color(resource.color))
                        VStack(alignment: .leading) {
                            Text(resource.nombre)
                                .font(.subheadline.weight(.medium))
                            Text("\(resource.cantidad) / \(resource.minimoRequerido) requeridos")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        // Progress bar
                        ProgressView(value: min(Double(resource.cantidad) / Double(resource.minimoRequerido), 1.0))
                            .tint(Color(resource.color))
                            .frame(width: 60)
                    }
                    .padding(12)
                    .background(Color(resource.color).opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }

    private func refreshData() {
        familias = DataManager.shared.familias
        tareas = DataManager.shared.tareas
        recursos = DataManager.shared.recursos
    }
}

#Preview {
    ResumenView()
}
