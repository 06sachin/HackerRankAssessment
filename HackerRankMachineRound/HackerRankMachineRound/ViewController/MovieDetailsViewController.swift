//
//  MovieDetailsViewController.swift
//  HackerRankMachineRound
//
//  Created by SACHIN on 27/10/24.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    
    // MARK: - Outlets -
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var castCrewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingControlView: RatingControl!

    // MARK: - Properties -
    var movie: MoviesData?

    // MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    deinit {
        print("Dealloc called")
    }
}

// MARK: - Setup UI -
extension MovieDetailViewController {
    private func setupData() {
        guard let movie = movie else { return }
        titleLabel.text = "Title: \(movie.title ?? "")"
        plotLabel.text = "Plot: \(movie.plot ?? "")"
        castCrewLabel.text = "Cast & Crew: \(movie.actors ?? "")"
        releaseDateLabel.text = "Release Date: \(movie.released ?? "")"
        genreLabel.text = "Genre: \(movie.genre ?? "")"
        
        if let posterURLString = movie.poster,
           let posterURL = URL(string: posterURLString) {
            URLSession.shared.dataTask(with: posterURL) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.posterImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        if let ratings = movie.ratings {
            ratingControlView.configure(with: ratings)
        }
    }
}

// MARK: - Action Methods -
extension MovieDetailViewController {
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
