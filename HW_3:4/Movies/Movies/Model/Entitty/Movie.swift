//
//  Movie.swift
//  Movies
//
//  Created by Павел Калинин on 21.12.2024.
//

struct Movie: Codable {
    let id: Int
    let title: String
    let description: String?
    let yearOfPublication: Int?
    let trailerUrl: String?
    let stars: String?
    let runningTime: Int?
    let poster: Image
    let images: [Image]?
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, poster, description = "body_text", yearOfPublication = "year", trailerUrl = "trailer", stars, runningTime = "running_time", images, genres
    }
}
