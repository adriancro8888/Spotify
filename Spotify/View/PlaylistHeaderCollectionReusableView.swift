//
//  PlaylistHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Amr Hossam on 12/09/2021.
//

import UIKit
import SDWebImage

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = .secondaryLabel

        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let playAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30,
                                                                                                    weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(imageView)
        addSubview(playAllButton)
        playAllButton.addTarget(
            self,
            action: #selector(didTapPlayAll),
            for: .touchUpInside
        )
    }
    
    @objc private func didTapPlayAll() {
        delegate?.PlaylistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with viewModel: PlaylistHeaderViewViewModel) {
        imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        ownerLabel.text = viewModel.ownerName
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = height / 1.5
        imageView.frame = CGRect(x: (width - imageSize) / 2, y: 2, width: imageSize, height: imageSize)
        
        nameLabel.frame = CGRect(
            x: 10,
            y: imageView.bottom,
            width: width - 20,
            height: 44
        )
        
        descriptionLabel.frame = CGRect(
            x: 10,
            y: nameLabel.bottom,
            width: width - 20,
            height: 44
        )
        
        ownerLabel.frame = CGRect(
            x: 10,
            y: descriptionLabel.bottom,
            width: width - 20,
            height: 44
        )
        
        playAllButton.frame = CGRect(x: width - 80, y: height - 80, width: 60, height: 60)
        
    }
}
