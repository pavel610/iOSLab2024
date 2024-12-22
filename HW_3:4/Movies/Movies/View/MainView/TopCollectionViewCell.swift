//
//  TopCollectionViewCell.swift
//  Movies
//
//  Created by Павел Калинин on 21.12.2024.
//

import UIKit

class TopCollectionViewCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private lazy var numberLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFill
        label.font = .systemFont(ofSize: 100, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(numberLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -15),
            numberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 45),
        ])
    }
    
    func configure(with movie: Movie, index: Int) {
        numberLabel.text = "\(index + 1)"
        Task {
            imageView.image = try? await ImageService.shared.downloadImage(url: movie.poster.image)
        }
    }
}

extension TopCollectionViewCell {
    static let reusableIdentifier = "TopCollectionViewCell"
}
