//
//  UpcomingTableViewCell.swift
//  Netflix
//
//  Created by Dalveer singh on 16/04/22.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    static let identifier = "TitleTableViewCell"
    
    private let titlePosterImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
//        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    private let playButton:UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.label
        return button
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlePosterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)
        applyConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func applyConstraints(){
        let titlePosterImageViewConstraints = [
            titlePosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            titlePosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),
            titlePosterImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: titlePosterImageView.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        let playButtonConstraints = [
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(titlePosterImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
    }
    public func configure(with model:Title)
    {

        if(model.poster_path != nil){
            let url = URL(string: "\(Constants.image_url)\(model.poster_path!)")
            titlePosterImageView.sd_setImage(with: url, completed: nil)
        
        }
        titleLabel.text = model.original_name ?? model.original_title ?? "Unknown"
//        print(model)
    }
}
