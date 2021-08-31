//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Amr Hossam on 29/08/2021.
//

import UIKit

class WelcomeViewController: UIViewController {

    
    private let signInButton: UIButton = {
       
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign in with Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        view.backgroundColor = .systemGreen
        title = "Spotify"
        view.addSubview(signInButton)
        signInButton.addTarget(self,
                               action: #selector(didTapSignInButton),
                               for: .touchUpInside)
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        signInButton.frame = CGRect(
            x: 20,
            y: view.height-50-view.safeAreaInsets.bottom,
            width: view.width-40,
            height: 50)
        
        
        
        
        
    }
 

    
    @objc private func didTapSignInButton() {
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
        self?.handleSignIn(success: success)
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        // log user in or yell at them an error
    }
}
