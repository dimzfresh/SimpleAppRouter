//
//  Session.swift
//  SimpleAppRouter
//
//  Created by Dmitrii Ziablikov on 19/02/2019.
//  Copyright © 2019 dimzfresh. All rights reserved.
//

import Foundation

typealias Credentials = (username: String, password: String)

struct Session {
    static var isAuthorized: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isAuthorized")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isAuthorized")
        }
    }
}
