//
//  PhotoCell.swift
//  PhotoSafe
//
//  Created by Sarah Clark on 7/25/25.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        // Add Core Animation for fade-in
        imageView.alpha = 0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }

    func configure(with image: UIImage) {
        imageView.image = image
        // Animate fade-in
        UIView.animate(withDuration: 0.3) {
            self.imageView.alpha = 1
        }
    }
}

// MARK: UI Preview
#Preview {
    let previewCell = PhotoCell()
    return previewCell
}
