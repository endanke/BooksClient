//
//  BookListViewModel.swift
//  BooksClient
//
//  Created by Daniel Eke on 2019. 03. 21..
//  Copyright © 2019. Daniel Eke. All rights reserved.
//

import Foundation
import RxSwift

class BookListViewModel {
    
    private let bookApi: BookApi

    let books: Observable<[Book]>

    var searchText = BehaviorSubject<String>(value: "")
    
    init(bookApi: BookApi) {
        self.bookApi = bookApi
        
        books = searchText
            .asObservable()
            .flatMapLatest { searchString -> Observable<[Book]> in
                guard !searchString.isEmpty else {
                    return Observable.empty()
                }
                return bookApi.search(title: searchString)
            }
            .observeOn(MainScheduler.instance)
            .share(replay: 1)
    }
    
}
