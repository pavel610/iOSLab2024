//
//  DetailView.swift
//  Movies
//
//  Created by Павел Калинин on 23.12.2024.
//

import UIKit

class DetailView: UIView {
    let imagesCollectionView: ImagesCollectionView = {
        let imagesCollectionView = ImagesCollectionView()
        imagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return imagesCollectionView
    }()
    
    let segmentedControl: CustomSegmentedControl<String> = {
        let segmentedControl = CustomSegmentedControl<String>(items: ["О фильме", "Каст", "Трейлер"], titleProvider: { $0 })
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    let descriptionView: DescriptionView = {
        let descriptionView = DescriptionView()
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        return descriptionView
    }()
    
    private lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(contentView)
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imagesCollectionView)
        view.addSubview(posterImageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionView)
        view.addSubview(segmentedControl)
        return view
    }()
    
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView(image: .example)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColors.mainColor
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(scrollView)
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -60),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imagesCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imagesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagesCollectionView.heightAnchor.constraint(equalToConstant: 210),
            
            posterImageView.widthAnchor.constraint(equalToConstant: 95),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            posterImageView.topAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: -50),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            titleLabel.topAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: 10),
            
            descriptionView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            descriptionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            descriptionView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - 50),
            
            segmentedControl.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func configure(with movie: Movie?) {
        guard let movie = movie else { return }
        descriptionView.configure(with: movie)
        titleLabel.text = movie.title
        Task {
            posterImageView.image = try await ImageService.shared.downloadImage(url: movie.poster.image)
        }
    }
}
