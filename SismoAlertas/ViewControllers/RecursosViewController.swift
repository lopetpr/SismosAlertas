import UIKit

final class RecursosViewController: UITableViewController {

    private var recursos: [Resource] { DataManager.shared.recursos }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recursos"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.rowHeight = 60

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addRecursoTapped)
        )

        NotificationCenter.default.addObserver(
            self, selector: #selector(dataDidChange),
            name: DataManager.dataDidChangeNotification, object: nil
        )
    }

    @objc private func dataDidChange() {
        tableView.reloadData()
    }

    @objc private func addRecursoTapped() {
        let alert = UIAlertController(title: "Nuevo Recurso", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Nombre del recurso" }
        alert.addTextField { $0.placeholder = "Cantidad"; $0.keyboardType = .numberPad }
        alert.addTextField { $0.placeholder = "Mínimo requerido"; $0.keyboardType = .numberPad }

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Agregar", style: .default) { _ in
            guard let nombre = alert.textFields?[0].text, !nombre.isEmpty,
                  let cantStr = alert.textFields?[1].text, let cantidad = Int(cantStr),
                  let minStr = alert.textFields?[2].text, let minimo = Int(minStr) else { return }
            let resource = Resource(nombre: nombre, cantidad: cantidad, minimoRequerido: minimo)
            DataManager.shared.addResource(resource)
        })
        present(alert, animated: true)
    }

    // MARK: - DataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recursos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ResourceCell")
        let resource = recursos[indexPath.row]

        cell.textLabel?.text = resource.nombre
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)

        cell.detailTextLabel?.text = "Cantidad: \(resource.cantidad) / Mínimo: \(resource.minimoRequerido)"
        cell.detailTextLabel?.textColor = .secondaryLabel

        // Color from model — no conditional in VC
        let dot = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        dot.backgroundColor = resource.color
        dot.layer.cornerRadius = 6

        let iconIV = UIImageView(image: UIImage(systemName: resource.icon))
        iconIV.tintColor = resource.color
        cell.accessoryView = iconIV

        cell.imageView?.image = UIImage(systemName: "circle.fill")
        cell.imageView?.tintColor = resource.color

        return cell
    }

    // MARK: - Delegate — tap to edit quantity

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var resource = recursos[indexPath.row]

        let alert = UIAlertController(title: "Actualizar \(resource.nombre)", message: "Cantidad actual: \(resource.cantidad)", preferredStyle: .alert)
        alert.addTextField { tf in
            tf.placeholder = "Nueva cantidad"
            tf.keyboardType = .numberPad
            tf.text = "\(resource.cantidad)"
        }
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Actualizar", style: .default) { _ in
            guard let text = alert.textFields?.first?.text, let qty = Int(text) else { return }
            resource.cantidad = qty
            DataManager.shared.updateResource(resource)
        })
        present(alert, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManager.shared.deleteResource(at: indexPath.row)
        }
    }
}
