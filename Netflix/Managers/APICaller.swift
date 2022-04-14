//
//  APICaller.swift
//  Netflix
//
//  Created by Dalveer singh on 15/04/22.
//

import Foundation
enum APIError:Error{
    case failedToLoadData
}
enum TrendingType{
    case movie
    case tv
}
class APICaller{
    static let shared = APICaller()
    
    func getTrendingMoviesOrTvs(type:TrendingType,completion: @escaping(Result<[Movie],Error>)->Void)
    {
        guard let url = URL(string: "\(Constants.baseUrl)3/trending/\(type)/week?api_key=\(Constants.API_KEY)") else {return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,error == nil else { return }
            do{
//                let results = try JSONSerialization.jsonObject(with:  data, options: .allowFragments)
//                print(results)
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
//                print(results.results)
                completion(.success(results.results))
                
            }
            catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
    func getUpcomingMovies(completion: @escaping(Result<[Movie],Error>)->Void){
        guard let url = URL(string: "\(Constants.baseUrl)3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return }
        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,error == nil else { return }
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                print(results.results)
                completion(.success(results.results))
                
            }
            catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
    func getPopular(completion: @escaping(Result<[Movie],Error>)->Void){
        guard let url = URL(string: "\(Constants.baseUrl)3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return }
        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,error == nil else { return }
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                print(results.results)
                completion(.success(results.results))
                
            }
            catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
    func getTopRated(completion: @escaping(Result<[Movie],Error>)->Void){
        guard let url = URL(string: "\(Constants.baseUrl)3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return }
        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,error == nil else { return }
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                print(results.results)
                completion(.success(results.results))
                
            }
            catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

