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
    private(set) var moviesByCategory: [String: [MoviesData]] = [:]  // Map genre to movies
    
    var expandedSections: [SectionType: Bool] = [:]
    
    init() {
        loadMovies()
        groupMovies()
        SectionType.allCases.forEach { expandedSections[$0] = false }
    }
    
    private func loadMovies() {
        if let url = Bundle.main.url(forResource: "movies", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            self.movies = (try? decoder.decode([MoviesData].self, from: data)) ?? []
        }
    }
    
    private func groupMovies() {
        groupedData[.year] = Array(Set(movies.compactMap { $0.year })).sorted()
        groupedData[.genre] = Array(Set(movies.flatMap { $0.genre?.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } ?? [] })).sorted()
        groupedData[.directors] = Array(Set(movies.flatMap { $0.director?.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } ?? [] })).sorted()
        groupedData[.actors] = Array(Set(movies.flatMap { $0.actors?.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } ?? [] })).sorted()
        
        // Map movies to each individual genre, director, etc.
        for movie in movies {
            if let genres = movie.genre?.split(separator: ",").map({ $0.trimmingCharacters(in: .whitespaces) }) {
                for genre in genres {
                    moviesByCategory[genre, default: []].append(movie)
                }
            }
            if let directors = movie.director?.split(separator: ",").map({ $0.trimmingCharacters(in: .whitespaces) }) {
                for director in directors {
                    moviesByCategory[director, default: []].append(movie)
                }
            }
            if let actors = movie.actors?.split(separator: ",").map({ $0.trimmingCharacters(in: .whitespaces) }) {
                for actor in actors {
                    moviesByCategory[actor, default: []].append(movie)
                }
            }
        }
    }
    
    func toggleSection(_ section: SectionType) {
        expandedSections[section]?.toggle()
    }

    func isSectionExpanded(_ section: SectionType) -> Bool {
        return expandedSections[section] ?? false
    }
    
    func itemsInSection(_ section: SectionType) -> [Any] {
        switch section {
        case .allMovies:
            return movies // Full movie list
        case .year, .genre, .directors, .actors:
            // Only unique values for grouped sections
            return groupedData[section] ?? []
        }
    }
    
    func searchMovies(query: String) -> [MoviesData] {
        let searchText = query.lowercased()
        return movies.filter { movie in
            return (movie.title?.lowercased().contains(searchText) ?? false) ||
                   (movie.genre?.lowercased().contains(searchText) ?? false) ||
                   (movie.director?.lowercased().contains(searchText) ?? false) ||
                   (movie.actors?.lowercased().contains(searchText) ?? false)
        }
    }


    // Filtering method
    func movies(for category: SectionType, with value: String) -> [MoviesData] {
        return movies.filter { movie in
            switch category {
            case .genre:
                return movie.genre?.contains(value) ?? false
            case .actors:
                return movie.actors?.contains(value) ?? false
            case .directors:
                return movie.director?.contains(value) ?? false
            case .year:
                return movie.year == value
            case .allMovies:
                return true // No filtering for "All Movies"
            }
        }
    }
}
