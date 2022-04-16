//
//  YoutubeSearchResponse.swift
//  Netflix
//
//  Created by Dalveer singh on 17/04/22.
//

import Foundation
/*
 items =     (
             {
         etag = "zVUdYoYNuccpXIyV-RwWwPa05mE";
         id =             {
             kind = "youtube#video";
             videoId = "_dJH0RxSQK4";
         };
         kind = "youtube#searchResult";
     },
*/
struct YouTubeSearchResponse:Codable{
    let items:[VideoDescription]
}
struct VideoDescription:Codable{
    let id:IdVideoDescription
}
struct IdVideoDescription:Codable{
    let kind:String
    let videoId:String
}
