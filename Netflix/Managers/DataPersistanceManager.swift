//
//  DataPersistanceManager.swift
//  Netflix
//
//  Created by Dalveer singh on 18/04/22.
//

import Foundation
import UIKit
import CoreData
class DataPersistanceManager{
    enum DownloadDataBaseError:Error{
        case failedToSave
        case failtedToFetch
        case failtedTodeleteItem
    }
    static let shared = DataPersistanceManager()
    func downloadTitle(with model:Title,completion : @escaping(Result<Void,Error>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let item = TitleItem(context: context)
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.original_name = model.original_name
        item.overview = model.overview
        item.media_type = model.media_type
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average
        do{
            try context.save()
            completion(.success(()))
        }
        catch{
            print(error.localizedDescription)
            completion(.failure(DownloadDataBaseError.failedToSave))
        }
    }
    func fetchingTitlesFromDatabase(completion : @escaping(Result<[TitleItem],Error>)->Void)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let request:NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        do{
           let titles =  try context.fetch(request)
            completion(.success(titles))
        }
        catch{
            completion(.failure(DownloadDataBaseError.failtedToFetch))
            print(error)
        }
    }
    func deleteTitlesWith(model:TitleItem,completion:@escaping(Result<Void,Error>)->Void)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        do{
            try context.save()
            completion(.success(()))
        
        }
        catch{
            completion(.failure(DownloadDataBaseError.failtedTodeleteItem))
        }
        
    }
}
