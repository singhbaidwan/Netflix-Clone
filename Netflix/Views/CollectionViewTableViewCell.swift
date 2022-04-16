//
//  CollectionViewTableViewCell.swift
//  Netflix
//
//  Created by Dalveer singh on 13/04/22.
//

import UIKit
protocol CollectionViewTableViewCellDelegate:AnyObject{
    func collectionViewTableViewCellDidTapCell(_ cell:CollectionViewTableViewCell,viewModel:TitlePreviewViewModel)
}
class CollectionViewTableViewCell: UITableViewCell {
    static let identifier = "CollectionViewTableViewCell"
    weak var delegate:CollectionViewTableViewCellDelegate?
    private var titles:[Title] = [Title]()
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func configure(with titles:[Title])
    {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}
extension CollectionViewTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        guard let path = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: path)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title else {return}
        APICaller.shared.getMovie(with: titleName+"trailer") { [weak self]result in
            switch result{
            case .success(let videoDescription):
                let name =  self?.titles[indexPath.row].original_name ?? self?.titles[indexPath.row].original_title ?? ""
                guard let strongself = self else {return}
                let overview = self?.titles[indexPath.row].overview ?? ""
                let previewModel = TitlePreviewViewModel(title:name, overview: overview, youtubeView: videoDescription)
                strongself.delegate?.collectionViewTableViewCellDidTapCell(strongself, viewModel: previewModel)
            case .failure(let error):
                print(error)
            }
        }
    }
}
