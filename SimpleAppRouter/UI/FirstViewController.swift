//
//  FirstViewController.swift
//  SimpleAppRouter
//
//  Created by Dmitrii Ziablikov on 19/02/2019.
//  Copyright © 2019 dimzfresh. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

private extension FirstViewController {
    func setup() {
        addCustomRightBarButton()
    }
    
    func addCustomRightBarButton() {
        addNavigationButton(title: "Forward", isLeft: false, selector: #selector(customRightBarButtonTapped))
    }
    
    @objc func customRightBarButtonTapped() {
        Router.instance.showSecondScene()
    }
}

