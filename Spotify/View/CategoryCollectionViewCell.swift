//
//  CategoryCollectionViewCell.swift
//  Spotify
//
//  Created by Amr Hossam on 16/09/2021.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    private let imageView: UIImageView = {
       
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(
            systemName: "music.quarternote.3",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 50,
                weight: .regular)
        )
        return imageView
    }()
    
    private let colors: [UIColor] = [
        .systemBlue,
        .systemPink,
        .systemPink,
        .systemTeal,
        .systemOrange,
        .systemYellow,
        .systemPurple,
        .systemRed,
        .systemIndigo,
        .systemGreen,
        .darkGray,
        .systemGray2
    ]
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        imageView.image = UIImage(
            systemName: "music.quarternote.3",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 50,
                weight: .regular)
        )
    }
    
    func configure(with viewModel: CategoryCollectionViewCellViewModel) {
        label.text = viewModel.title
        contentView.backgroundColor = colors.randomElement()
        imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 10, y: contentView.height / 2, width: contentView.width - 20, height: contentView.height / 2)
        imageView.frame = CGRect(x: contentView.width / 2, y: 10, width: contentView.width / 2, height: contentView.height / 2)
    }
}
