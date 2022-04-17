//
//  SearchResultViewController.swift
//  Netflix
//
//  Created by Dalveer singh on 17/04/22.
//

import UIKit

protocol SearchResultViewControllerDelegate:AnyObject{
    func SearchResultViewControllerDidTapItem(_ viewModel:TitlePreviewViewModel)
}

class SearchResultViewController: UIViewController {
    public var titles:[Title] = [Title]()
    public weak var delegate:SearchResultViewControllerDelegate?
    public let searchResultsCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
}

extension SearchResultViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else
        {
            return UICollectionViewCell()
        }
         var path = titles[indexPath.row].poster_path ?? ""
         cell.configure(with: path)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title else {return}

        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result{
            case .success(let video):
                self?.delegate?.SearchResultViewControllerDidTapItem(TitlePreviewViewModel(title: titleName, overview: title.overview ?? "", youtubeView: video))
            case .failure(let error):
                print(error)
            }
        }
    }
}
