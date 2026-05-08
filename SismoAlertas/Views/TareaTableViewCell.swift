import UIKit

final class TareaTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TareaCell"

    private let statusDot: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 6
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let tituloLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let descripcionLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let responsableLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .medium)
        l.textColor = .tertiaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let estadoBadge: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 11, weight: .bold)
        l.textAlignment = .center
        l.layer.cornerRadius = 8
        l.clipsToBounds = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(statusDot)
        contentView.addSubview(tituloLabel)
        contentView.addSubview(descripcionLabel)
        contentView.addSubview(responsableLabel)
        contentView.addSubview(estadoBadge)

        NSLayoutConstraint.activate([
            statusDot.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusDot.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            statusDot.widthAnchor.constraint(equalToConstant: 12),
            statusDot.heightAnchor.constraint(equalToConstant: 12),

            tituloLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            tituloLabel.leadingAnchor.constraint(equalTo: statusDot.trailingAnchor, constant: 10),
            tituloLabel.trailingAnchor.constraint(lessThanOrEqualTo: estadoBadge.leadingAnchor, constant: -8),

            descripcionLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 4),
            descripcionLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            descripcionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            responsableLabel.topAnchor.constraint(equalTo: descripcionLabel.bottomAnchor, constant: 4),
            responsableLabel.leadingAnchor.constraint(equalTo: tituloLabel.leadingAnchor),
            responsableLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            estadoBadge.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            estadoBadge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            estadoBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            estadoBadge.heightAnchor.constraint(equalToConstant: 22),
        ])
    }

    func configure(with task: BrigadeTask) {
        tituloLabel.text = task.titulo
        descripcionLabel.text = task.descripcion
        responsableLabel.text = task.responsable.isEmpty ? "Sin asignar" : task.responsable

        // Color from enum — no switch in cell
        statusDot.backgroundColor = task.estado.color
        estadoBadge.text = "  \(task.estado.rawValue)  "
        estadoBadge.backgroundColor = task.estado.color.withAlphaComponent(0.15)
        estadoBadge.textColor = task.estado.color
    }
}
