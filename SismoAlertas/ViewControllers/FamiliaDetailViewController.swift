import UIKit

final class FamiliaDetailViewController: UIViewController {

    private var family: Family

    init(family: Family) {
        self.family = family
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI

    private let scrollView = UIScrollView()
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let statusBadge: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .bold)
        l.textAlignment = .center
        l.layer.cornerRadius = 12
        l.clipsToBounds = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let notasTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 15)
        tv.layer.borderColor = UIColor.separator.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 8
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = family.nombre
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        setupLayout()
        populateData()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Guardar",
            style: .done,
            target: self,
            action: #selector(saveTapped)
        )
    }

    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
        ])

        // Status badge
        stackView.addArrangedSubview(statusBadge)
        statusBadge.heightAnchor.constraint(equalToConstant: 44).isActive = true

        // Info cards
        addInfoCard(title: "Dirección", value: family.direccion, icon: "mappin.circle.fill")
        addInfoCard(title: "Integrantes", value: "\(family.integrantes) personas", icon: "person.2.fill")
        if !family.necesidadesEspeciales.isEmpty {
            addInfoCard(title: "Necesidades Especiales", value: family.necesidadesEspeciales, icon: "heart.fill")
        }

        // Status change button
        let changeStatusButton = UIButton(type: .system)
        changeStatusButton.setTitle("Cambiar Estado", for: .normal)
        changeStatusButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        changeStatusButton.backgroundColor = .systemBlue
        changeStatusButton.setTitleColor(.white, for: .normal)
        changeStatusButton.layer.cornerRadius = 12
        changeStatusButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        changeStatusButton.addTarget(self, action: #selector(changeStatusTapped), for: .touchUpInside)
        stackView.addArrangedSubview(changeStatusButton)

        // Notas section
        let notasLabel = UILabel()
        notasLabel.text = "Notas"
        notasLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        stackView.addArrangedSubview(notasLabel)

        notasTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        stackView.addArrangedSubview(notasTextView)
    }

    private func addInfoCard(title: String, value: String, icon: String) {
        let card = UIView()
        card.backgroundColor = .secondarySystemBackground
        card.layer.cornerRadius = 12

        let iconIV = UIImageView(image: UIImage(systemName: icon))
        iconIV.tintColor = .systemBlue
        iconIV.translatesAutoresizingMaskIntoConstraints = false

        let titleL = UILabel()
        titleL.text = title
        titleL.font = .systemFont(ofSize: 12, weight: .medium)
        titleL.textColor = .secondaryLabel
        titleL.translatesAutoresizingMaskIntoConstraints = false

        let valueL = UILabel()
        valueL.text = value
        valueL.font = .systemFont(ofSize: 15, weight: .regular)
        valueL.numberOfLines = 0
        valueL.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(iconIV)
        card.addSubview(titleL)
        card.addSubview(valueL)

        NSLayoutConstraint.activate([
            iconIV.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            iconIV.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            iconIV.widthAnchor.constraint(equalToConstant: 24),
            iconIV.heightAnchor.constraint(equalToConstant: 24),

            titleL.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            titleL.leadingAnchor.constraint(equalTo: iconIV.trailingAnchor, constant: 12),
            titleL.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),

            valueL.topAnchor.constraint(equalTo: titleL.bottomAnchor, constant: 2),
            valueL.leadingAnchor.constraint(equalTo: titleL.leadingAnchor),
            valueL.trailingAnchor.constraint(equalTo: titleL.trailingAnchor),
            valueL.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
        ])

        stackView.addArrangedSubview(card)
    }

    private func populateData() {
        updateStatusBadge()
        notasTextView.text = family.notas
    }

    private func updateStatusBadge() {
        statusBadge.text = "  \(family.estado.rawValue)  "
        statusBadge.backgroundColor = family.estado.color.withAlphaComponent(0.15)
        statusBadge.textColor = family.estado.color
    }

    // MARK: - Actions

    @objc private func changeStatusTapped() {
        let alert = UIAlertController(title: "Cambiar Estado", message: "Selecciona el nuevo estado", preferredStyle: .actionSheet)
        for status in FamilyStatus.allCases {
            alert.addAction(UIAlertAction(title: status.rawValue, style: .default) { [weak self] _ in
                self?.family.estado = status
                self?.updateStatusBadge()
            })
        }
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func saveTapped() {
        family.notas = notasTextView.text ?? ""
        DataManager.shared.updateFamily(family)
        navigationController?.popViewController(animated: true)
    }
}
