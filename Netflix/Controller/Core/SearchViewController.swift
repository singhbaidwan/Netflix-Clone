//
//  SearchViewController.swift
//  Netflix
//
//  Created by Dalveer singh on 13/04/22.
//

import UIKit

class SearchViewController: UIViewController {
    var titles:[Title] = [Title]()
    private let tableView:UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    private let searchController:UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search for Movie or Tv show"
        controller.searchBar.searchBarStyle = .minimal
        
        return controller
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = UIColor.label
        navigationItem.searchController = searchController
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        searchController.searchResultsUpdater = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        fetchDiscoverMovies()
    }
    private func fetchDiscoverMovies(){
        APICaller.shared.getDiscoverMovies { [weak self]result in
            switch result{
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SearchViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier,for: indexPath) as? TitleTableViewCell else
        {
            return UITableViewCell()
        }
        cell.configure(with: titles[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title else {return}
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result{
            case .success(let video):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, overview: title.overview ?? "", youtubeView: video))
                    self?.navigationController?.pushViewController(vc, animated: true)}
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension SearchViewController:UISearchResultsUpdating,SearchResultViewControllerDelegate{
    func SearchResultViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async {[weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count>=3,
              let resultsController = searchController.searchResultsController as? SearchResultViewController
        else {return}
        resultsController.delegate = self
        APICaller.shared.searchWithQuery(with: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
    
    
}
