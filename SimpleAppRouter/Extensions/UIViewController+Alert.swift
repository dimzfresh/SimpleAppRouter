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

extension UIViewController {
    
    var isModal: Bool {
        return presentingViewController != nil
    }
    
    func showAlert(title: String?, message: String, dismiss: Bool = false) {
   
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
        alert.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: { (action: UIAlertAction!) in
            
            if dismiss {
                if self.isModal {
                    self.dismiss(animated: true)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func addNavigationButton(title: String?, image: UIImage?, tintColor: UIColor = UIColor(red: 0.61, green: 0.61, blue: 0.61, alpha: 1), isLeft: Bool, selector: Selector, font: UIFont? = nil) {
        
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
