//
//  APICaller.swift
//  Netflix
//
//  Created by Dalveer singh on 15/04/22.
//

import Foundation
import UIKit
enum APIError:Error{
    case failedToLoadData
}
enum TrendingType{
    case movie
    case tv
}
class APICaller{
    static let shared = APICaller()
    
    func getTrendingMoviesOrTvs(type:TrendingType,completion: @escaping(Result<[Title],Error>)->Void)
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
                completion(.failure(APIError.failedToLoadData))
            }
        }
        task.resume()
    }
    func getUpcomingMovies(completion: @escaping(Result<[Title],Error>)->Void){
        guard let url = URL(string: "\(Constants.baseUrl)3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return }
//        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,error == nil else { return }
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
//                print(results.results)
                completion(.success(results.results))
                
            }
            catch{
                completion(.failure(APIError.failedToLoadData))
            }
        }
        task.resume()
    }
    func getPopular(completion: @escaping(Result<[Title],Error>)->Void){
        guard let url = URL(string: "\(Constants.baseUrl)3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return }
//        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,error == nil else { return }
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
//                print(results.results)
                completion(.success(results.results))
                
            }
            catch{
                completion(.failure(APIError.failedToLoadData))
            }
        }
        task.resume()
    }
    func getTopRated(completion: @escaping(Result<[Title],Error>)->Void){
        guard let url = URL(string: "\(Constants.baseUrl)3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return }
//        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,error == nil else { return }
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
//                print(results.results)
                completion(.success(results.results))
                
            }
            catch{
                completion(.failure(APIError.failedToLoadData))
            }
        }
        task.resume()
    }
    
    func getDiscoverMovies(completion: @escaping(Result<[Title],Error>)->Void){

        guard let url = URL(string: "\(Constants.baseUrl)3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&page=1&timezone=America%2FNew_York&include_null_first_air_dates=false&with_watch_monetization_types=flatrate&with_status=0&with_type=0") else {return }
//        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,error == nil else { return }
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
//                print(results.results)
                completion(.success(results.results))
                
            }
            catch{
                completion(.failure(APIError.failedToLoadData))
            }
        }
        task.resume()
    }
    
    
    func searchWithQuery(with query:String,completion: @escaping(Result<[Title],Error>)->Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.baseUrl)3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {return }
//        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,error == nil else { return }
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
//                print(results.results)
                completion(.success(results.results))
                
            }
            catch{
                completion(.failure(APIError.failedToLoadData))
            }
        }
        task.resume()
    }
    func getMovie(with query:String,completion: @escaping(Result<VideoDescription,Error>)->Void)
    {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.youTubeBaseURL)q=\(query)&key=\(Constants.YouTubeAPI_KEY)") else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,error == nil else { return }
            do{
                let result = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)
                completion(.success(result.items[0]))
            }
            catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

