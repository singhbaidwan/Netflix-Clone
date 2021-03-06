//
//  HeroHeaderUIView.swift
//  Netflix
//
//  Created by Dalveer singh on 14/04/22.
//

import UIKit

class HeroHeaderUIView: UIView {
    private let downloadButton:UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    private let playButton:UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let HeroImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "poster")
        imageView.clipsToBounds = true
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(HeroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        HeroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    private func applyConstraints(){
        let playuButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        let downloadButtonConstrains = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(playuButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstrains)
    }
    public func configure(with model:Title)
    {
        if(model.poster_path != nil){
            let url = URL(string: "\(Constants.image_url)\(model.poster_path!)")
            HeroImageView.sd_setImage(with: url, completed: nil)
        }
    }
}
