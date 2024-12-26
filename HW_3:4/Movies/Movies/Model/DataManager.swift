//
//  DataManager.swift
//  Movies
//
//  Created by Павел Калинин on 22.12.2024.
//
import UIKit

class DataManager {
    static let shared = DataManager()
    private var nextUrl: String?

    private init() {}
    
    func obtainTopMovies() async throws -> [Movie]{
        let urlString = "https://kudago.com/public-api/v1.4/movies/?page_size=10&order_by=budget"
        
        guard let url = URL(string: urlString) else { return []}
        let responseData = try await URLSession.shared.data(from: url)

        let movies = try JSONDecoder().decode(MainResponse.self, from: responseData.0).results
        return movies
    }
    
    func obtainCities() async throws -> [City]{
        let urlString = "https://kudago.com/public-api/v1.2/locations/?lang=ru"
        
        guard let url = URL(string: urlString) else { return []}
        let responseData = try await URLSession.shared.data(from: url)
        
        let cities = try JSONDecoder().decode([City].self, from: responseData.0)
        return cities
    }
    
    func obtainAllMovies(in city: City) async throws -> [Movie] {
        let urlString = "https://kudago.com/public-api/v1.4/movies/?page_size=21&location=\(city.slug)"
        
        guard let url = URL(string: urlString) else { return []}
        let responseData = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MainResponse.self, from: responseData.0)
        nextUrl = response.next
        return response.results
    }
    
    func obtainNextPageAllMovies() async throws -> [Movie]{
        guard let urlString = nextUrl, let url = URL(string: urlString) else { return []}
        
        let responseData = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MainResponse.self, from: responseData.0)
        nextUrl = response.next
        return response.results
    }
    
    func obtainDetailInfoById(id: Int) async throws -> Movie? {
        let urlString = "https://kudago.com/public-api/v1.4/movies/\(id)/"
        
        guard let url = URL(string: urlString) else { return nil}
        let responseData = try await URLSession.shared.data(from: url)
        let movie = try JSONDecoder().decode(Movie.self, from: responseData.0)
        return movie
    }
}
