import UIKit

final class AddTareaViewController: UITableViewController {

    private let fields = ["Título", "Descripción", "Responsable"]
    private var textFields: [UITextField] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nueva Tarea"
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
        guard let titulo = textFields[safe: 0]?.text, !titulo.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "El título es obligatorio", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let descripcion = textFields[safe: 1]?.text ?? ""
        let responsable = textFields[safe: 2]?.text ?? ""

        let task = BrigadeTask(
            titulo: titulo,
            descripcion: descripcion,
            responsable: responsable
        )
        DataManager.shared.addTask(task)
        dismiss(animated: true)
    }

    // MARK: - DataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fields.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Información de la Tarea"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "TaskFieldCell")
        let tf = UITextField()
        tf.placeholder = fields[indexPath.row]
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = .systemFont(ofSize: 16)

        cell.contentView.addSubview(tf)
        NSLayoutConstraint.activate([
            tf.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            tf.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
            tf.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            tf.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
        ])

        if textFields.count <= indexPath.row {
            textFields.append(tf)
        } else {
            textFields[indexPath.row] = tf
        }

        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - Safe Array Access
private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
