//
//  MoviesViewModel.swift
//  HackerRankMachineRound
//
//  Created by SACHIN on 27/10/24.
//

import Foundation

enum SectionType: Int, CaseIterable {
    case year, genre, directors, actors, allMovies

    var title: String {
        switch self {
        case .year: return "Year"
        case .genre: return "Genre"
        case .directors: return "Directors"
        case .actors: return "Actors"
        case .allMovies: return "All Movies"
        }
    }
}

final class MoviesViewModel {
    private(set) var movies: [MoviesData] = []
    private(set) var groupedData: [SectionType: [String]] = [:]
    var expandedSections: [SectionType: Bool] = [:]

    init() {
        // Load data and group movies
        loadMovies()
        groupMovies()
        SectionType.allCases.forEach { expandedSections[$0] = false }
    }

    private func loadMovies() {
        if let url = Bundle.main.url(forResource: "movies", withExtension: "json"), let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            self.movies = (try? decoder.decode([MoviesData].self, from: data)) ?? []
        }
    }

    private func groupMovies() {
        groupedData[.year] = Array(Set(movies.compactMap { $0.year })).sorted()
        groupedData[.genre] = Array(Set(movies.compactMap { $0.genre })).sorted()
        groupedData[.directors] = Array(Set(movies.compactMap { $0.director })).sorted()
        groupedData[.actors] = Array(Set(movies.flatMap { $0.actors?.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } ?? [] })).sorted()
    }
    
    // Updated searchMovies function for comprehensive matching
    func searchMovies(query: String) -> [MoviesData] {
        let searchText = query.lowercased()  // Convert search query to lowercase
        debugPrint("Search text", searchText)
        return movies.filter { movie in
            // Check each field for the presence of the search term
            return (movie.title?.lowercased().contains(searchText) ?? false) ||
            (movie.genre?.lowercased().contains(searchText) ?? false) ||
            (movie.director?.lowercased().contains(searchText) ?? false) ||
            (movie.actors?.lowercased().contains(searchText) ?? false)
        }
    }

    func toggleSection(_ section: SectionType) {
        expandedSections[section]?.toggle()
    }

    func isSectionExpanded(_ section: SectionType) -> Bool {
        return expandedSections[section] ?? false
    }

    func itemsInSection(_ section: SectionType) -> [String] {
        return groupedData[section] ?? []
    }

    func numberOfMovies() -> Int {
        return movies.count
    }
}
