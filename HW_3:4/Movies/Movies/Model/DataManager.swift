//
//  DataManager.swift
//  Movies
//
//  Created by Павел Калинин on 22.12.2024.
//
import UIKit

class DataManager {
    static let shared = DataManager()
    var top10: [Movie] = []
    
    private init() {
        Task {
            top10 = try await obtainTopMovies()
        }
    }
    
//    func getCities() async -> [String:String] {
//        guard let url = URL(string: "https://kudago.com/public-api/v1.2/locations/?lang=ru") else { return [:]}
//        
//        let responseData = try? await URLSession.shared.data(from: url)
//        
//    }
    
    func obtainTopMovies() async throws -> [Movie]{
        let urlString = "https://kudago.com/public-api/v1.4/movies/?fields=id,poster,title,body_text,genres,year,running_time,trailer,stars,images&location=kzn"
        
        guard let url = URL(string: urlString) else { return []}
        let responseData = try await URLSession.shared.data(from: url)

        let movies = try JSONDecoder().decode(MainResponse.self, from: responseData.0).results
        return movies
    }
}
