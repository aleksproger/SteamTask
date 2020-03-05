//
//  GameTableViewCell.swift
//  SteamTask
//
//  Created by Alex on 26.11.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 80, height: 80))
    var gameName: UILabel = UILabel(frame: .zero)
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
    }
    override init(frame: CGRect) {
        super.init(frame: .zero)
        gameName.text = ""
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        gameName.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(imageView)
        self.contentView.addSubview(gameName)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            gameName.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            gameName.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            gameName.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            //gameName.topAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
        //self.imageView.contentMode = .scaleAspectFit
        self.gameName.textAlignment = .center
        self.gameName.font = self.gameName.font.withSize(10)
        self.gameName.numberOfLines = 2

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
