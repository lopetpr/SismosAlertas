import UIKit

final class FamiliaTableViewCell: UITableViewCell {
    static let reuseIdentifier = "FamiliaCell"

    // MARK: - UI Elements

    private let badgeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let statusIcon: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let nombreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let direccionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let integrantesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .tertiaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let estadoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        accessoryType = .disclosureIndicator

        contentView.addSubview(badgeView)
        badgeView.addSubview(statusIcon)
        contentView.addSubview(nombreLabel)
        contentView.addSubview(direccionLabel)
        contentView.addSubview(integrantesLabel)
        contentView.addSubview(estadoLabel)

        NSLayoutConstraint.activate([
            // Badge circle
            badgeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            badgeView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            badgeView.widthAnchor.constraint(equalToConstant: 40),
            badgeView.heightAnchor.constraint(equalToConstant: 40),

            statusIcon.centerXAnchor.constraint(equalTo: badgeView.centerXAnchor),
            statusIcon.centerYAnchor.constraint(equalTo: badgeView.centerYAnchor),
            statusIcon.widthAnchor.constraint(equalToConstant: 20),
            statusIcon.heightAnchor.constraint(equalToConstant: 20),

            // Labels stack
            nombreLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nombreLabel.leadingAnchor.constraint(equalTo: badgeView.trailingAnchor, constant: 12),
            nombreLabel.trailingAnchor.constraint(lessThanOrEqualTo: estadoLabel.leadingAnchor, constant: -8),

            direccionLabel.topAnchor.constraint(equalTo: nombreLabel.bottomAnchor, constant: 2),
            direccionLabel.leadingAnchor.constraint(equalTo: nombreLabel.leadingAnchor),
            direccionLabel.trailingAnchor.constraint(equalTo: nombreLabel.trailingAnchor),

            integrantesLabel.topAnchor.constraint(equalTo: direccionLabel.bottomAnchor, constant: 2),
            integrantesLabel.leadingAnchor.constraint(equalTo: nombreLabel.leadingAnchor),
            integrantesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            // Estado badge
            estadoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            estadoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            estadoLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            estadoLabel.heightAnchor.constraint(equalToConstant: 22),
        ])
    }

    // MARK: - Configure
    // Key: color derived from enum computed property — no switch here

    func configure(with family: Family) {
        nombreLabel.text = family.nombre
        direccionLabel.text = family.direccion
        integrantesLabel.text = "\(family.integrantes) integrantes"

        // Badge color from enum — no conditional logic in cell
        badgeView.backgroundColor = family.estado.color
        statusIcon.image = UIImage(systemName: family.estado.icon)

        // Estado label — color also from enum
        estadoLabel.text = "  \(family.estado.rawValue)  "
        estadoLabel.backgroundColor = family.estado.color.withAlphaComponent(0.15)
        estadoLabel.textColor = family.estado.color
    }
}
