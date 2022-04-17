//
//  DownloadViewController.swift
//  Netflix
//
//  Created by Dalveer singh on 13/04/22.
//

import UIKit

class DownloadViewController: UIViewController {
    private var titles:[TitleItem] = [TitleItem]()
    private let downloadTable:UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(downloadTable)
        downloadTable.delegate = self
        downloadTable.dataSource = self
        FetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: Notification.Name("Downloaded"), object: nil, queue: nil) { _ in
            self.FetchLocalStorageForDownload()
        }
    }
    private func FetchLocalStorageForDownload(){
        DataPersistanceManager.shared.fetchingTitlesFromDatabase {[weak self] result in
            switch result{
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.downloadTable.reloadData()}
            case .failure(let error):
                print(error)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }
}
extension DownloadViewController:UITableViewDelegate,UITableViewDataSource{
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
        let titleItem = titles[indexPath.row]
        let title = Title(id: Int(titleItem.id), media_type: titleItem.media_type, original_title: titleItem.original_title, original_name: titleItem.original_name, overview: titleItem.overview, title: titleItem.title, poster_path: titleItem.poster_path, vote_count: Int(titleItem.vote_count), release_date: titleItem.release_date, vote_average: titleItem.vote_average)
        cell.configure(with: title)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case .delete:
            DataPersistanceManager.shared.deleteTitlesWith(model: titles[indexPath.row]) { [weak self] result in
                switch result{
                case .success():
                    print("Deleted")
                case .failure(let error):
                    print(error)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        default:
            break
        }
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
