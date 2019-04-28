//
//  DetailViewController.swift
//  SimpleAppRouter
//
//  Created by Dmitrii Ziablikov on 28/04/2019.
//  Copyright © 2019 dimzfresh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

private extension DetailViewController {
    func setup() {
        addCustomLeftBarButton()
    }
    
    func addCustomLeftBarButton() {
        addNavigationButton(title: "Close", selector: #selector(customLeftBarButtonTapped))
    }
    
    @objc func customLeftBarButtonTapped() {
        Router.instance.dismiss()
    }
}
