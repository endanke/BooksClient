//
//  BookDetailViewController.swift
//  BooksClient
//
//  Created by Daniel Eke on 2019. 03. 21..
//  Copyright © 2019. Daniel Eke. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher
import SafariServices

class BookDetailViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var openInfoButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    var viewModel: BookDetailViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func bindViewModel() {
        // Set GUI content
        titleLabel.text = viewModel.book.title
        authorsLabel.text = viewModel.book.authors.joined(separator: ", ")
        thumbImageView!.kf.setImage(with: URL(string: viewModel.book.thumbnail),
                                    options: [.transition(.fade(0.2))])
        backgroundImageView!.kf.setImage(with: URL(string: viewModel.book.thumbnail),
                                         options: [.transition(.fade(0.2))])
        
        // Set tap action listeners
        openInfoButton.rx.tap
            .bind {
                let svc = SFSafariViewController(url: URL(string: self.viewModel.book.infoLink)!)
                self.present(svc, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        dismissButton.rx.tap
            .bind {
                self.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }

}
