//
//  MainViewController.swift
//  SimpleAppRouter
//
//  Created by Dmitrii Ziablikov on 19/02/2019.
//  Copyright © 2019 dimzfresh. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

}

private extension MainViewController {
    func setup() {
        addCustomLeftBarButton()
    }
    
    func addCustomLeftBarButton() {
        addNavigationButton(title: "Выйти", image: nil, tintColor: UIColor.blue.withAlphaComponent(0.6), isLeft: true, selector: #selector(customLeftBarButtonTapped))
    }
    
    @objc func customLeftBarButtonTapped() {
        Router.instance.switchTo(.start)
    }
}
