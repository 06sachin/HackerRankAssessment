//
//  CustomSectionHeaderView.swift
//  HackerRankMachineRound
//
//  Created by SACHIN on 28/10/24.
//

import UIKit

final class CustomSectionHeaderView: UITableViewHeaderFooterView {
    static let identifier = "CustomSectionHeaderView"

    let titleLabel = UILabel()
    let arrowImageView = UIImageView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        // Configure title label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        contentView.addSubview(titleLabel)
        
        // Configure arrow image view
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.image = UIImage(named: "backIcon") // Initial forward arrow
        arrowImageView.contentMode = .scaleAspectFit
        contentView.addSubview(arrowImageView)
        
        // Set layout constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 16),
            arrowImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }

    // Method to rotate the arrow based on expansion
    func setArrowDirection(isExpanded: Bool) {
        // Mirror the image by flipping horizontally
        let initialTransform = CGAffineTransform(scaleX: -1, y: 1)
        let rotationTransform = CGAffineTransform(rotationAngle: isExpanded ? .pi / 2 : 0)
        
        UIView.animate(withDuration: 0.3) {
            // Combine mirroring with rotation for expanded/collapsed state
            self.arrowImageView.transform = initialTransform.concatenating(rotationTransform)
        }
    }
}

