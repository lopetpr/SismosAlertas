import UIKit

final class TareasViewController: UITableViewController {

    private var allTareas: [BrigadeTask] { DataManager.shared.tareas }
    private var filteredTareas: [BrigadeTask] = []
    private var currentFilter: TaskStatus?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tareas Brigada"
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.register(TareaTableViewCell.self, forCellReuseIdentifier: TareaTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        setupFilterControl()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTareaTapped)
        )

        NotificationCenter.default.addObserver(
            self, selector: #selector(dataDidChange),
            name: DataManager.dataDidChangeNotification, object: nil
        )

        applyFilter()
    }

    // MARK: - Segmented Filter

    private func setupFilterControl() {
        let items = ["Todas"] + TaskStatus.allCases.map { $0.rawValue }
        let segmented = UISegmentedControl(items: items)
        segmented.selectedSegmentIndex = 0
        segmented.addTarget(self, action: #selector(filterChanged(_:)), for: .valueChanged)
        navigationItem.titleView = segmented
    }

    @objc private func filterChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currentFilter = nil
        } else {
            currentFilter = TaskStatus.allCases[sender.selectedSegmentIndex - 1]
        }
        applyFilter()
    }

    private func applyFilter() {
        if let filter = currentFilter {
            filteredTareas = allTareas.filter { $0.estado == filter }
        } else {
            filteredTareas = allTareas
        }
        tableView.reloadData()
    }

    @objc private func dataDidChange() {
        applyFilter()
    }

    @objc private func addTareaTapped() {
        let addVC = AddTareaViewController()
        let nav = UINavigationController(rootViewController: addVC)
        present(nav, animated: true) // Modal presentation
    }

    // MARK: - DataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredTareas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TareaTableViewCell.reuseIdentifier, for: indexPath) as? TareaTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: filteredTareas[indexPath.row])
        return cell
    }

    // MARK: - Delegate — tap to cycle status

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var task = filteredTareas[indexPath.row]

        let alert = UIAlertController(title: "Cambiar Estado", message: task.titulo, preferredStyle: .actionSheet)
        for status in TaskStatus.allCases {
            let action = UIAlertAction(title: status.rawValue, style: .default) { _ in
                task.estado = status
                DataManager.shared.updateTask(task)
            }
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = filteredTareas[indexPath.row]
            if let realIndex = allTareas.firstIndex(where: { $0.id == task.id }) {
                DataManager.shared.deleteTask(at: realIndex)
            }
        }
    }
}
