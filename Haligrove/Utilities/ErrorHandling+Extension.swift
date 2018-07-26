//
//  ErrorHandling+Extension.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit
import Firebase

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
            
        case .emailAlreadyInUse:
            return "This email already exists: Try logging in"
            
        case .userNotFound:
            return "User not found: Check username and try again"
            
        case .networkError:
            return "Check internet connection and try again"
            
        case .invalidEmail:
            return "invalid email"
            
        case .wrongPassword:
            return "invalid password"
            
        case .requiresRecentLogin:
            return "required login"
            
        case .userTokenExpired:
            return "user token expired please login"
            
        case .userMismatch:
            return "user mismatch: check username and try again"
            
        case .weakPassword:
            return "weak password: please use at least 7 characters"
            
        case .appNotAuthorized:
            return "authorization failed: check credentials and try again"
            
        case .missingEmail:
            return "fill in email"
            
        case .missingPhoneNumber:
            return "missing phone number"
            
        case .invalidPhoneNumber:
            return "not a valid phone number"
            
        case .sessionExpired:
            return "session expired: please login again"
            
        default:
            return "unknown error occured: check credentials and try again, if problem persists email: info@haligrove.com"
        }
    }
}

extension UIViewController {
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            print(errorCode.errorMessage)
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
