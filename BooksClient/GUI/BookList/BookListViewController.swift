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
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        viewModel = BookListViewModel(bookApi: BookApi())
        addBindsToViewModel(viewModel: viewModel)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func addBindsToViewModel(viewModel: BookListViewModel) {
        bookTitleSearchField.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        viewModel.books
            .bind(to: tableView.rx.items(cellIdentifier: "BookListTableViewCell", cellType: BookListTableViewCell.self)) { (row, element, cell) in
                cell.titleLabel.text = element.title
                cell.authorsLabel.text = element.authors.joined(separator: ", ")
                cell.thumbnailImageView!.kf.setImage(with: URL(string: element.thumbnail), options: [.transition(.fade(0.2))])
            }
            .disposed(by: disposeBag)
    }
}

extension BookListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
