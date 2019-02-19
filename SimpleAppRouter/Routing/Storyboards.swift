//
//  Storyboards.swift
//  SimpleAppRouter
//
//  Created by Dmitrii Ziablikov on 19/02/2019.
//  Copyright © 2019 dimzfresh. All rights reserved.
//

import UIKit

public enum Storyboards: String {
    case splash = "LaunchScreen"
    case start
    case main = "Main"

    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
    
    static func getFlow() -> Storyboards {
        switch Session.isAuthorized {
        case false:
            return .start
        case true:
            return .main
        }
    }
}
