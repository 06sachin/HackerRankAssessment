
import UIKit

final class RatingControl: UIView {
    
    // Define buttons and label
    private let imdbButton = UIButton(type: .system)
    private let rottenTomatoesButton = UIButton(type: .system)
    private let metacriticButton = UIButton(type: .system)
    private let ratingLabel = UILabel()

    private var ratings: [Ratings] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        // Configure each button
        imdbButton.setTitle("IMDB", for: .normal)
        imdbButton.addTarget(self, action: #selector(imdbButtonTapped), for: .touchUpInside)

        rottenTomatoesButton.setTitle("Rotten Tomatoes", for: .normal)
        rottenTomatoesButton.addTarget(self, action: #selector(rottenTomatoesButtonTapped), for: .touchUpInside)

        metacriticButton.setTitle("Metacritic", for: .normal)
        metacriticButton.addTarget(self, action: #selector(metacriticButtonTapped), for: .touchUpInside)

        // Configure rating label
        ratingLabel.textAlignment = .center
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 16)
        ratingLabel.text = "Rating: N/A"

        // Add buttons and label to the view
        addSubview(imdbButton)
        addSubview(rottenTomatoesButton)
        addSubview(metacriticButton)
        addSubview(ratingLabel)

        // Set constraints for buttons and label
        setupConstraints()
    }

    private func setupConstraints() {
        // Disable autoresizing masks for Auto Layout
        [imdbButton, rottenTomatoesButton, metacriticButton, ratingLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // Arrange buttons in a horizontal line at the top
        NSLayoutConstraint.activate([
            imdbButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            imdbButton.topAnchor.constraint(equalTo: topAnchor),
            
            rottenTomatoesButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            rottenTomatoesButton.topAnchor.constraint(equalTo: topAnchor),

            metacriticButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            metacriticButton.topAnchor.constraint(equalTo: topAnchor),
            
            // Rating label positioned below buttons
            ratingLabel.topAnchor.constraint(equalTo: imdbButton.bottomAnchor, constant: 16),
            ratingLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            ratingLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    // Configure method to set ratings data
    func configure(with ratings: [Ratings]) {
        self.ratings = ratings
        showRating(for: "Internet Movie Database")  // Default rating
    }

    // Button actions
    @objc private func imdbButtonTapped() {
        showRating(for: "Internet Movie Database")
    }

    @objc private func rottenTomatoesButtonTapped() {
        showRating(for: "Rotten Tomatoes")
    }

    @objc private func metacriticButtonTapped() {
        showRating(for: "Metacritic")
    }

    // Method to display the rating for a given source
    private func showRating(for source: String) {
        if let rating = ratings.first(where: { $0.source == source }) {
            ratingLabel.text = "\(source): \(rating.value ?? "N/A")"
        } else {
            ratingLabel.text = "\(source): N/A"
        }
    }
}
