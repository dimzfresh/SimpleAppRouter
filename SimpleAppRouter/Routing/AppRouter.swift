//
//  AppRouter.swift
//  SimpleAppRouter
//
//  Created by Dmitrii Ziablikov on 19/02/2019.
//  Copyright © 2019 dimzfresh. All rights reserved.
//

import UIKit

public protocol Routable: class {
    var window: UIWindow? { get }

    var navigationController: UINavigationController { get }
    var rootViewController: UIViewController? { get }
    
    func present(_ module: Presentable, animated: Bool)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func push(_ module: Presentable, animated: Bool, completion: (() -> Void)?)
    func pop(animated: Bool)
    func setRoot(_ module: Presentable, hideBar: Bool, animated: Bool)
    func popToRoot(animated: Bool)
}

public final class Router: NSObject, Routable {
    
    static let instance = Router()
    
    private(set) public var window: UIWindow?
    
    private var completions: [UIViewController : () -> Void]
    
    public var rootViewController: UIViewController? {
        return navigationController.viewControllers.first
    }
    
    public var hasRootController: Bool {
        return rootViewController != nil
    }
    
    public let navigationController: UINavigationController
    
    private init(navigationController: UINavigationController = UINavigationController()) {
        self.window = (UIApplication.shared.delegate as? AppDelegate)?.window
        self.navigationController = navigationController
        self.completions = [:]
        super.init()
        self.navigationController.delegate = self
    }
    
    private var rootController: UIViewController! {
        didSet {
            self.window?.rootViewController?.dismiss(animated: false)
            self.window?.rootViewController = self.toPresentable()
            self.window?.makeKeyAndVisible()
            
            setRoot(self.rootController)
        }
    }
}

// MARK: - Navigation Flow

extension Router: UINavigationControllerDelegate {
    
    public func setRoot(_ module: Presentable, hideBar: Bool = false, animated: Bool = false) {
        let viewController = module.toPresentable()
        
        completions.forEach { $0.value() }
        
        UIView.transition(with: viewController.view,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
        
        navigationController.setViewControllers([viewController], animated: animated)
        //navigationController.viewControllers = [viewController]
        navigationController.isNavigationBarHidden = hideBar
    }
    
    public func present(_ module: Presentable, animated: Bool = true) {
        navigationController.present(module.toPresentable(), animated: animated)
    }
    
    public func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    public func push(_ module: Presentable, animated: Bool = true, completion: (() -> Void)? = nil) {
        let controller = module.toPresentable()
        
        // Avoid pushing UINavigationController into stack
        guard (controller is UINavigationController) == false else { return }
        
        if let completion = completion {
            completions[controller] = completion
        }
        
        navigationController.pushViewController(controller, animated: animated)
    }
    
    public func pop(animated: Bool = true)  {
        guard let controller = navigationController.popViewController(animated: animated) else { return }
        completion(for: controller)
    }
    
    public func popToRoot(animated: Bool) {
        guard let controllers = navigationController.popToRootViewController(animated: animated) else { return }
        controllers.forEach { completion(for: $0) }
    }
    
    private func wrapInNavigationController(vc: UIViewController) -> UINavigationController {
        return UINavigationController(rootViewController: vc)
    }
    
    fileprivate func completion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
    
    // MARK: Presentable
    
    public func toPresentable() -> UIViewController {
        return navigationController
    }
    
    // MARK: UINavigationControllerDelegate
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        // Ensure the view controller is popping
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(poppedViewController) else {
                return
        }
        
        completion(for: poppedViewController)
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
    
    private func detailFlowController() -> UIViewController {
        let detailVC: DetailViewController = DetailViewController.instanceController(storyboard: .main)
        return detailVC
    }
}

// MARK: - Scenes

extension Router {
    func showStartScene(animated: Bool = true) {
        let vc = startFlowController()
        push(vc, animated: animated)
    }
    
    func showSecondScene(animated: Bool = true) {
        let secondVC: SecondViewController = SecondViewController.instanceController(storyboard: .main)
        push(secondVC, animated: animated)
    }
    
    func loadMainScene(animated: Bool = true) {
        let vc = mainFlowController()
        let wrappedVC = wrapInNavigationController(vc: vc)
        present(wrappedVC, animated: animated)
    }
    
    func loadDetailScene(animated: Bool = true) {
        let vc = detailFlowController()
        let wrappedVC = wrapInNavigationController(vc: vc)
        present(wrappedVC, animated: animated)
    }
}
