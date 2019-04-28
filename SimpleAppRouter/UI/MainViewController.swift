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
        addCustomRightBarButton()

        setSessionStatus()
    }
    
    func setSessionStatus() {
        Session.isAuthorized = true
    }
    
    func addCustomLeftBarButton() {
        addNavigationButton(title: "Exit", selector: #selector(customLeftBarButtonTapped))
    }
    
    @objc func customLeftBarButtonTapped() {
        showExitAlert(title: "Want to logout?", actionTitles: ["confirm", "cancel"])
    }
    
    func addCustomRightBarButton() {
        addNavigationButton(title: "Detail", isLeft: false, selector: #selector(customRightBarButtonTapped))
    }
    
    @objc func customRightBarButtonTapped() {
        Router.instance.loadDetailScene()
    }
}
