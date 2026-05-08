import UIKit

final class AddFamiliaViewController: UITableViewController {

    private let fields = ["Nombre", "Dirección", "Integrantes", "Necesidades Especiales"]
    private var textFields: [UITextField] = []
    private var selectedStatus: FamilyStatus = .noLocalizado

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nueva Familia"
        view.backgroundColor = .systemGroupedBackground

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Guardar",
            style: .done,
            target: self,
            action: #selector(saveTapped)
        )

        tableView = UITableView(frame: .zero, style: .insetGrouped)
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func saveTapped() {
        guard let nombre = textFields[safe: 0]?.text, !nombre.isEmpty,
              let direccion = textFields[safe: 1]?.text, !direccion.isEmpty,
              let integrantesStr = textFields[safe: 2]?.text, let integrantes = Int(integrantesStr) else {
            let alert = UIAlertController(title: "Error", message: "Completa nombre, dirección e integrantes", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let necesidades = textFields[safe: 3]?.text ?? ""
        let family = Family(
            nombre: nombre,
            direccion: direccion,
            integrantes: integrantes,
            necesidadesEspeciales: necesidades,
            estado: selectedStatus
        )
        DataManager.shared.addFamily(family)
        dismiss(animated: true)
    }

    // MARK: - DataSource

    override func numberOfSections(in tableView: UITableView) -> Int { 2 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? fields.count : 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Información" : "Estado Inicial"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "FieldCell")
            let tf = UITextField()
            tf.placeholder = fields[indexPath.row]
            tf.translatesAutoresizingMaskIntoConstraints = false
            tf.font = .systemFont(ofSize: 16)

            if indexPath.row == 2 {
                tf.keyboardType = .numberPad
            }

            cell.contentView.addSubview(tf)
            NSLayoutConstraint.activate([
                tf.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
                tf.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
                tf.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                tf.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
            ])

            // Store reference
            if textFields.count <= indexPath.row {
                textFields.append(tf)
            } else {
                textFields[indexPath.row] = tf
            }

            cell.selectionStyle = .none
            return cell
        } else {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "StatusCell")
            cell.textLabel?.text = "Estado"
            cell.detailTextLabel?.text = selectedStatus.rawValue
            cell.detailTextLabel?.textColor = selectedStatus.color
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 1 else { return }

        let alert = UIAlertController(title: "Estado Inicial", message: nil, preferredStyle: .actionSheet)
        for status in FamilyStatus.allCases {
            alert.addAction(UIAlertAction(title: status.rawValue, style: .default) { [weak self] _ in
                self?.selectedStatus = status
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - Safe Array Access
private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
