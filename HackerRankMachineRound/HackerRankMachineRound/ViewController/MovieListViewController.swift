//
//  ViewController.swift
//  HackerRankMachineRound
//
//  Created by SACHIN on 27/10/24.
//

import UIKit

protocol ConfigurableCell {
    func configure(with data: Any)
}

final class MovieListViewController: UIViewController {
    
    // MARK: - Outlets -
    @IBOutlet weak var movieListTableView: UITableView!

    private let viewModel = MoviesViewModel()
    private var filteredMovies: [MoviesData] = []  // Stores search results
    private var isSearching = false  // Track if search is active
    private var selectedCategory: SectionType?
    private var selectedValue: String?

    // MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}

// MARK: - Setup TableView -
extension MovieListViewController {
    fileprivate func setupTableView() {
        movieListTableView.register(UINib(nibName: String(describing: AllMoviesTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AllMoviesTableViewCell.self))
        movieListTableView.register(UINib(nibName: String(describing: MoviesTableViewCell.self), bundle: nil), forCellReuseIdentifier:String(describing: MoviesTableViewCell.self))
        movieListTableView.register(CustomSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: CustomSectionHeaderView.identifier)
        movieListTableView.dataSource = self
        movieListTableView.delegate = self
    }
    
    @objc func handleSectionTap(_ sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag, let sectionType = SectionType(rawValue: section) else { return }
        viewModel.toggleSection(sectionType)
        movieListTableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource -
extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - Table View Sections and Rows
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? 1 : SectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredMovies.count
        } else {
            let sectionType = SectionType(rawValue: section)!
            return viewModel.isSectionExpanded(sectionType) ? viewModel.itemsInSection(sectionType).count : 0
        }
    }
    
    // MARK: - Cell Configuration
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = SectionType(rawValue: indexPath.section)!
        
        // Check if we are in search mode
        if isSearching {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoviesTableViewCell.self), for: indexPath) as! MoviesTableViewCell
            cell.selectionStyle = .none
            cell.configure(with: filteredMovies[indexPath.row])
            return cell
        }
        
        // Determine the cell identifier based on the section type for non-search cases
        let cellIdentifier = sectionType == .allMovies 
                                            ? String(describing: MoviesTableViewCell.self)
                                            : String(describing: AllMoviesTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        
        // Determine the data to be passed to the cell based on the section type
        let data: Any = sectionType == .allMovies 
                                        ? viewModel.itemsInSection(.allMovies)[indexPath.row]
                                        : viewModel.itemsInSection(sectionType)[indexPath.row]
        
        (cell as? ConfigurableCell)?.configure(with: data)
        
        return cell
    }

    // MARK: - Cell Selection Handling
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieDetailVC = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController else {
            return
        }
        
        if isSearching {
            movieDetailVC.movie = filteredMovies[indexPath.row]
        } else {
            let sectionType = SectionType(rawValue: indexPath.section)!
            
            if sectionType == .allMovies {
                if let movie = viewModel.itemsInSection(.allMovies)[indexPath.row] as? MoviesData {
                    movieDetailVC.movie = movie
                }
            } else {
                if let selectedValue = viewModel.itemsInSection(sectionType)[indexPath.row] as? String {
                    let moviesForSelectedValue = viewModel.movies(for: sectionType, with: selectedValue)
                    
                    if let firstMovie = moviesForSelectedValue.first {
                        movieDetailVC.movie = firstMovie
                    }
                }
            }
        }
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }

    // MARK: - Section Header for Expand/Collapse -
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !isSearching,
              let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomSectionHeaderView.identifier) as? CustomSectionHeaderView else {
            return nil
        }

        let sectionType = SectionType(rawValue: section)!
        headerView.titleLabel.text = sectionType.title
        let isExpanded = viewModel.isSectionExpanded(sectionType)
        headerView.setArrowDirection(isExpanded: isExpanded)
        
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
