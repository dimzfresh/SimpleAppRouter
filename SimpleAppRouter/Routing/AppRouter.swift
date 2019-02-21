//
//  AppRouter.swift
//  SimpleAppRouter
//
//  Created by Dmitrii Ziablikov on 19/02/2019.
//  Copyright © 2019 dimzfresh. All rights reserved.
//

import UIKit

final class Router {
    static let instance = Router()
    
    private var window: UIWindow?
    private weak var navigationController: UINavigationController?
    private weak var currentViewController: UIViewController?

    private init() {
        self.window = (UIApplication.shared.delegate as? AppDelegate)?.window
    }
    
    private var rootController: UIViewController! {
        didSet {
            self.window?.rootViewController?.dismiss(animated: false)
            let wrappedVC = wrapInNavigationController(vc: self.rootController)
            self.currentViewController = self.rootController
            self.navigationController = wrappedVC
            setRootViewController(wrappedVC)
        }
    }
    
    private func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard animated, let window = self.window else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
}

//MARK: - Application flow

extension Router {
    
    func start() {
        let flow = Storyboards.getFlow()
        switchTo(flow)
    }
    
    func switchTo(_ flow: Storyboards) {
        var flowController: UIViewController
        switch flow {
        case .splash:
            flowController = splashFlowController()
        case .start:
            flowController = startFlowController()
        case .main:
            flowController = mainFlowController()
        }
        rootController = flowController
    }
    
    private func splashFlowController() -> UIViewController {
        let splashVC = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        // FIXME: - change launch screen to xib
        return splashVC ?? UIViewController()
    }
    
    private func startFlowController() -> UIViewController {
        let startVC: FirstViewController = FirstViewController.instanceController(storyboard: .main)
        return startVC
    }
    
    private func mainFlowController() -> UIViewController {
        let mainVC: MainViewController = MainViewController.instanceController(storyboard: .main)
        return mainVC
    }
    
}

// MARK: - Scenes

extension Router {
    
    func showStartScene(animated: Bool = true) {
        let vc = startFlowController()
        present(vc: vc, animated: animated)
    }
    
    func showSecondScene(animated: Bool = true) {
        let secondVC: SecondViewController = SecondViewController.instanceController(storyboard: .main)
        present(vc: secondVC, animated: animated)
        currentViewController = secondVC
    }
    
    func loadMainScene(animated: Bool = true) {
        let vc = mainFlowController()
        let wrappedVC = wrapInNavigationController(vc: vc)
        presentModally(vc: wrappedVC, animated: animated)
    }
    
}

// MARK: - Navigation Flow

extension Router {
    
    func present(vc: UIViewController, animated: Bool) {
        guard !presentWithNavigationController(vc: vc, animated: animated) else { return }
        
        presentModally(vc: vc, animated: animated)
    }
    
    func presentWithNavigationController(vc: UIViewController, animated: Bool) -> Bool {
        guard let navigationController = navigationController else {
            return false
        }
        
        navigationController.pushViewController(vc, animated: animated)
        
        return true
    }
    
    func presentModally(vc: UIViewController, animated: Bool) {
        currentViewController?.present(vc, animated: animated)
    }
    
    func wrapInNavigationController(vc: UIViewController) -> UINavigationController {
        let navVC = UINavigationController(rootViewController: vc)
        return navVC
    }
    
    func dismiss(animated: Bool = true) {
        guard let navigationController = navigationController else {
            currentViewController?.dismiss(animated: animated)
            return
        }
        
        if currentViewController?.presentingViewController != nil {
            currentViewController?.dismiss(animated: animated)
            currentViewController = navigationController.viewControllers.last
        } else {
            navigationController.popViewController(animated: animated)
        }
    }

}
