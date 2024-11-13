//
//  AllMoviesTableViewCell.swift
//  HackerRankMachineRound
//
//  Created by SACHIN on 28/10/24.
//

import UIKit

final class AllMoviesTableViewCell: UITableViewCell {

    // MARK: - Outlets -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        arrowImage.rotate(degrees: 40)
    }
}

// Protocol conformance method
extension AllMoviesTableViewCell: ConfigurableCell {
    func configure(with data: Any) {
        if let title = data as? String {
            self.titleLabel?.text = title
        }
    }
}
