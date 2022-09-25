//
//  PexelResult.swift
//  Gratitude
//
//  Created by Yuvaraj on 20/09/22.
//

import Foundation

struct PexelSearchResult: Codable {
    enum CodingKeys: String, CodingKey {
        case totalResults   = "total_results"
        case page           = "page"
        case perPage        = "per_page"
        case photos         = "photos"
        case nextPageURL    = "next_page"
    }
    
    var totalResults: Int
    var page: Int
    var perPage: Int
    var photos: [PexelPhoto]
    var nextPageURL: String?
}

struct PexelPhoto: Codable {
    enum CodingKeys: String, CodingKey {
        case id                 = "id"
        case width              = "width"
        case height             = "height"
        case url                = "url"
        case photographer       = "photographer"
        case photographerURL    = "photographer_url"
        case photographerID     = "photographer_id"
        case avgColor           = "avg_color"
        case src                = "src"
        case liked              = "liked"
        case alt                = "alt"
    }
    
    var id: Int
    var width: Int
    var height: Int
    var url: String
    var photographer: String
    var photographerURL: String
    var photographerID: Int
    var avgColor: String
    var src: PexelSourceURL
    var liked: Bool
    var alt: String
}

struct PexelSourceURL: Codable {
    enum CodingKeys: String, CodingKey {
        case original       = "original"
        case large2X        = "large2x"
        case large          = "large"
        case medium         = "medium"
        case small          = "small"
        case landscape      = "landscape"
        case portrait       = "portrait"
        case tiny           = "tiny"
    }
    
    var original: String
    var large2X: String
    var large: String
    var medium: String
    var small: String
    var landscape: String
    var portrait: String
    var tiny: String
}
