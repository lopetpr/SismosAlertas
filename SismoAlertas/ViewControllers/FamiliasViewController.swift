import UIKit

final class FamiliasViewController: UITableViewController {

    private var familias: [Family] { DataManager.shared.familias }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Familias"
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.register(FamiliaTableViewCell.self, forCellReuseIdentifier: FamiliaTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80

        // Add button → Modal
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addFamiliaTapped)
        )

        NotificationCenter.default.addObserver(
            self, selector: #selector(dataDidChange),
            name: DataManager.dataDidChangeNotification, object: nil
        )
    }

    @objc private func dataDidChange() {
        tableView.reloadData()
    }

    @objc private func addFamiliaTapped() {
        let addVC = AddFamiliaViewController()
        let nav = UINavigationController(rootViewController: addVC)
        present(nav, animated: true) // Modal presentation
    }

    // MARK: - DataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        familias.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FamiliaTableViewCell.reuseIdentifier, for: indexPath) as? FamiliaTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: familias[indexPath.row])
        return cell
    }

    // MARK: - Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = FamiliaDetailViewController(family: familias[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true) // Push navigation
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManager.shared.deleteFamily(at: indexPath.row)
        }
    }
}
