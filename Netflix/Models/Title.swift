//
//  Movie.swift
//  Netflix
//
//  Created by Dalveer singh on 15/04/22.
//

import Foundation

struct TrendingMoviesResponse:Codable{
    let results:[Title]
}
struct Title:Codable{
    let id:Int
    let media_type:String?
    var original_title:String?
    let original_name:String?
    let overview:String?
    let title:String?
    let poster_path:String?
    let vote_count:Int
    let release_date:String?
    let vote_average:Double
}


//Result
//{
//adult = 0;
//"backdrop_path" = "/iQFcwSGbZXMkeyKrxbPnwnRo5fl.jpg";
//"genre_ids" =             (
//28,
//12,
//878
//);
//id = 634649;
//"media_type" = movie;
//"original_language" = en;
//"original_title" = "Spider-Man: No Way Home";
//overview = "Peter Parker is unmasked and no longer able to separate his normal life from the high-stakes of being a super-hero. When he asks for help from Doctor Strange the stakes become even more dangerous, forcing him to discover what it truly means to be Spider-Man.";
//popularity = "5792.421";
//"poster_path" = "/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg";
//"release_date" = "2021-12-15";
//title = "Spider-Man: No Way Home";
//video = 0;
//"vote_average" = "8.199999999999999";
//"vote_count" = 11398;
//}
