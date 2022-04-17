//
//  UpcomingViewController.swift
//  Netflix
//
//  Created by Dalveer singh on 13/04/22.
//

import UIKit

class UpcomingViewController: UIViewController {
    private var titles:[Title] = [Title]()
    private let upcomingTable:UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        fetchUpcoming()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    private func fetchUpcoming(){
        APICaller.shared.getUpcomingMovies { [weak self]result in
            switch result{
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async{
                    self?.upcomingTable.reloadData()
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension UpcomingViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier,for: indexPath) as? TitleTableViewCell else
        {
            let cell1 = UITableViewCell()
            cell1.textLabel?.text = "error"
            return cell1
        }
        cell.configure(with: titles[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
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
