//
//  UIViewController+Alert.swift
//  SimpleAppRouter
//
//  Created by Dmitrii Ziablikov on 19/02/2019.
//  Copyright © 2019 dimzfresh. All rights reserved.
//

import UIKit
import Foundation

extension NSObject {
    static var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UIViewController {
    class func instanceController<T>(storyboard: Storyboards) -> T {
        return storyboard.instance.instantiateViewController(withIdentifier: self.nameOfClass) as! T
    }
}

public protocol Presentable {
    func toPresentable() -> UIViewController
}

extension UIViewController: Presentable {
    public func toPresentable() -> UIViewController {
        return self
    }
}


extension UIViewController {
    
    func showExitAlert(title: String = "", actionTitles: [String] = [], message: String = "") {
        guard actionTitles.count == 2 else { return }
        
        let firstTitle = actionTitles.first ?? ""
        let lastTitle = actionTitles.last ?? ""
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: firstTitle, style: .default, handler: { (action: UIAlertAction!) in
            Session.isAuthorized = false
            Router.instance.switchTo(.start)
        }))
        
        if !lastTitle.isEmpty {
            alert.addAction(UIAlertAction(title: lastTitle, style: .cancel))
        }
        
        present(alert, animated: true)
    }
    
    func addNavigationButton(title: String?, image: UIImage? = nil, tintColor: UIColor =  UIColor.black.withAlphaComponent(0.6), isLeft: Bool = true, selector: Selector, font: UIFont? = nil) {
        
        let button = UIButton(type: .system)
        let originalImage = image
        //let scaledImage: UIImage = UIImage(cgImage: originalImage.cgImage!, scale: 30, orientation: originalImage.imageOrientation)
        button.setImage(originalImage, for: .normal)
        button.setTitle(title, for: .normal)
        if font != nil {
            button.titleLabel?.font = font
        }
        button.sizeToFit()
        //button.setTitleColor(.brown, for: .normal)
        button.tintColor = tintColor
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        if isLeft {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
    }
    
}
