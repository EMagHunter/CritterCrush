//
//  WikiImage.swift
//  Pen Pal
//https://stackoverflow.com/questions/54415777/need-help-parsing-wikipedia-json-api-in-swift
//  stole it from here
//For API call of Wiki

import Foundation
struct WikiImage: Decodable {
    
    var query: QueryStruct
    
}

struct QueryStruct: Decodable {
    
    var pages: [PageStruct]?
    
}

struct PageStruct: Decodable{
    
    var pageid: Int?
    var title: String?
    var thumbnail: ThumbStruct?
    var extract: String?
    
}

struct ThumbStruct: Decodable{
    
    var source: String?
    var width: Int?
    var height: Int?
    
}
