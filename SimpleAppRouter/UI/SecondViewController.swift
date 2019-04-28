//
//  SecondViewController.swift
//  SimpleAppRouter
//
//  Created by Dmitrii Ziablikov on 19/02/2019.
//  Copyright © 2019 dimzfresh. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setup()
    }
}

private extension SecondViewController {
    
    func setup() {
        addCustomLeftBarButton()
        addCustomRightBarButton()
    }
    
    func addCustomLeftBarButton() {
        addNavigationButton(title: "Back", selector: #selector(customLeftBarButtonTapped))
    }
    
    @objc func customLeftBarButtonTapped() {
        Router.instance.pop()
    }
    
    func addCustomRightBarButton() {
        addNavigationButton(title: "Main", isLeft: false, selector: #selector(customRightBarButtonTapped))
    }
    
    @objc func customRightBarButtonTapped() {
        Router.instance.loadMainScene()
    }
}

