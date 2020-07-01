
// Swift
//
// Add this to the header of your file, e.g. in ViewController.swift

import FBSDKLoginKit

// Add this to the body
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        let loginButton = FBLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
        loginButton.permissions = ["public_profile", "email"]
        
        if let token = AccessToken.current,
            !token.isExpired {
            // User is logged in, do work such as go to next view controller.
            print("logged in :)")
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
    
    }
    @IBAction func checkLoginBtn(_ sender: Any) {
        if let token = AccessToken.current,
            !token.isExpired {
            // User is logged in, do work such as go to next view controller.
            print("logged in :)")
            performSegue(withIdentifier: "loginSegue", sender: self)
        } else {
            print("not Logged in")
        }
    }
    
}

