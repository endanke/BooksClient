//
//  Book.swift
//  BooksClient
//
//  Created by Daniel Eke on 2019. 03. 21..
//  Copyright © 2019. Daniel Eke. All rights reserved.
//

import Foundation

struct Book {
    
    let id: String
    let title: String
    let authors: [String]
    let thumbnail: String
    let infoLink: String
    
    // In the original response the book details are stored in a nested document
    // For the sake of simplicity have flattened some parts of the data
    init(item: [String: Any]) {
        id = item["id"] as! String
        
        let info = item["volumeInfo"] as! [String: Any]
        let imageLinks = info["imageLinks"] as? [String: Any]

        title = info["title"] as! String
        infoLink = info["infoLink"] as! String
        
        if info["authors"] != nil {
            authors = info["authors"] as! [String]
        } else {
            authors = []
        }
        
        if imageLinks != nil {
            thumbnail = imageLinks!["thumbnail"] as! String
        } else {
            thumbnail = "https://via.placeholder.com/150"
        }
    }
}
