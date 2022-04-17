//
//  HomeViewController.swift
//  Netflix
//
//  Created by Dalveer singh on 13/04/22.
//

import UIKit

enum Sections:Int{
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    private var randomTrendingMovie:Title?
    private var headerView:HeroHeaderUIView?
    let sectionTitles = ["Trending Movies","Trending Tv","Popular","Upcoming Movies","Top Rated"]
    private let homeFeedTable:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        configureNavBar()
        configureHeroHeaderView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    private func configureHeroHeaderView(){
        APICaller.shared.getTrendingMoviesOrTvs(type: .movie) { [weak self] result in
            switch result{
            case .success(let titles):
                self?.randomTrendingMovie = titles.randomElement()
                guard let randomTrendingMovie = self?.randomTrendingMovie else {
                    return
                }
                self?.headerView?.configure(with: randomTrendingMovie)
            case .failure(let error):
                print(error)
            }
        }
    }
    private func configureNavBar(){
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action:  nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
            
        ]
        navigationController?.navigationBar.tintColor = UIColor.label
    }
    
}

extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell
        else
        {
            return UITableViewCell()
        }
        cell.delegate = self
        switch indexPath.section
        {
        case Sections.TrendingMovies.rawValue :
            APICaller.shared.getTrendingMoviesOrTvs(type: .movie) { result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingMoviesOrTvs(type: .tv) { result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopular { result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRated { result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offSet = scrollView.contentOffset.y+defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0,-offSet))
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return }
        header.textLabel?.font = .systemFont(ofSize: 18,weight:.semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x+20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = UIColor.label
        header.textLabel?.text = header.textLabel?.text?.capitailizeFirstLetter()
    }
}


extension HomeViewController:CollectionViewTableViewCellDelegate{
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async {[weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            //        vc.delegate = self
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
