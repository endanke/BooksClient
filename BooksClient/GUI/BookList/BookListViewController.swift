//
//  BookListViewController.swift
//  BooksClient
//
//  Created by Daniel Eke on 2019. 03. 21..
//  Copyright © 2019. Daniel Eke. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class BookListViewController: UIViewController {

    @IBOutlet weak var bookTitleSearchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: BookListViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BookListViewModel(bookApi: BookApi())
        bindViewModel()
    }
    
    private func bindViewModel() {
        // Bind text field to the viewModel to update search on text change
        bookTitleSearchField.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        // Load books in the custom cell
        viewModel.books
            .bind(to: tableView.rx.items(cellIdentifier: "BookListTableViewCell", cellType: BookListTableViewCell.self)) { (row, element, cell) in
                cell.titleLabel.text = element.title
                cell.authorsLabel.text = element.authors.joined(separator: ", ")
                cell.thumbnailImageView!.kf.setImage(with: URL(string: element.thumbnail),
                                                     options: [.transition(.fade(0.2))])
            }
            .disposed(by: disposeBag)
        
        // Open detail view on row selection
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let strongSelf = self else { return }
                let selectedBook: Book = try! strongSelf.tableView.rx.model(at: indexPath)
                let detailViewModel = BookDetailViewModel(book: selectedBook)
                let detailVC = strongSelf.storyboard?.instantiateViewController(withIdentifier: "BookDetailViewController") as! BookDetailViewController
                detailVC.viewModel = detailViewModel
                strongSelf.present(detailVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        // Delegate for size settings
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension BookListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
