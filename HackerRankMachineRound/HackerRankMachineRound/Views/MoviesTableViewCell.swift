//
//  MoviesTableViewCell.swift
//  HackerRankMachineRound
//
//  Created by SACHIN on 27/10/24.
//

import UIKit

final class MoviesTableViewCell: UITableViewCell {
    
    // MARK: - Outlets -
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 10
    }
}

// Protocol conformance method
extension MoviesTableViewCell: ConfigurableCell {
    func configure(with data: Any) {
        if let movie = data as? MoviesData {
            titleLabel.text = movie.title
            yearLabel.text = "Year: \(movie.year ?? "")"
            languageLabel.text = movie.language
            if let posterURLString = movie.poster,
               let posterURL = URL(string: posterURLString) {
                // Load image asynchronously
                URLSession.shared.dataTask(with: posterURL) { data, _, _ in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.posterImageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
        }
    }
}
