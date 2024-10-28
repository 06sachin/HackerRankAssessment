//
//  ViewController.swift
//  HackerRankMachineRound
//
//  Created by SACHIN on 27/10/24.
//

import UIKit

final class MovieListViewController: UIViewController {
    
    // MARK: - Outlets TableView -
    @IBOutlet weak var movieListTableView: UITableView!

    // MARK: - Properties -
    private let viewModel = MoviesViewModel()
    private var filteredMovies: [MoviesData] = []  // Stores search results
    private var isSearching = false  // Track if search is active
    
    // MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    deinit {
        print("Dealloc called")
    }
}

// MARK: - Setup TableView -
extension MovieListViewController {
    fileprivate func setupTableView() {
        movieListTableView.register(UINib(nibName: String(describing: AllMoviesTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AllMoviesTableViewCell.self))
        movieListTableView.register(UINib(nibName: String(describing: MoviesTableViewCell.self) , bundle: nil), forCellReuseIdentifier:String(describing:MoviesTableViewCell.self))
        movieListTableView.register(CustomSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: CustomSectionHeaderView.identifier)
        movieListTableView.dataSource = self
        movieListTableView.delegate = self
    }
    
    @objc func handleSectionTap(_ sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag, let sectionType = SectionType(rawValue: section) else { return }
        viewModel.toggleSection(sectionType)  /// Toggle expand/collapse state
        movieListTableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource -
extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? 1 : SectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredMovies.count
        } else {
            let sectionType = SectionType(rawValue: section)!
            if sectionType == .allMovies {
                return viewModel.isSectionExpanded(sectionType) ? viewModel.numberOfMovies() : 0
            }
            return viewModel.isSectionExpanded(sectionType) ? viewModel.itemsInSection(sectionType).count : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoviesTableViewCell.self) , for: indexPath) as? MoviesTableViewCell else {
                return UITableViewCell()
            }
            let movie = filteredMovies[indexPath.row]
            cell.selectionStyle = .none
            cell.configure(with: movie)
            return cell
        } else {
            let sectionType = SectionType(rawValue: indexPath.section)!
            
            if sectionType == .allMovies {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoviesTableViewCell.self) , for: indexPath) as? MoviesTableViewCell else { return UITableViewCell() }
                let movie = viewModel.movies[indexPath.row]
                cell.configure(with: movie)
                cell.selectionStyle = .none
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AllMoviesTableViewCell.self), for: indexPath) as? AllMoviesTableViewCell else { return UITableViewCell() }
                cell.titleLabel?.text = viewModel.itemsInSection(sectionType)[indexPath.row]
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieDetailVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController else { return }
        if isSearching {
            movieDetailVC.movie = filteredMovies[indexPath.row]
        } else {
            let sectionType = SectionType(rawValue: indexPath.section)!
            if sectionType == .allMovies {
                movieDetailVC.movie = viewModel.movies[indexPath.row]
            }
        }
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomSectionHeaderView.identifier) as? CustomSectionHeaderView else {
            return nil
        }

        // Set title and arrow direction based on section state
        headerView.titleLabel.text = SectionType(rawValue: section)?.title
        let isExpanded = viewModel.isSectionExpanded(SectionType(rawValue: section) ?? .year) // Your method to check if section is expanded
        headerView.setArrowDirection(isExpanded: isExpanded)
        
        // Add tap gesture recognizer to header view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSectionTap(_:)))
        headerView.addGestureRecognizer(tapGesture)
        headerView.tag = section
        
        return headerView
    }
}

// MARK: - UISearchBarDelegate -
extension MovieListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredMovies.removeAll()
        } else {
            isSearching = true
            filteredMovies = viewModel.searchMovies(query: searchText)
        }
        movieListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        filteredMovies.removeAll()
        movieListTableView.reloadData()
    }
}
