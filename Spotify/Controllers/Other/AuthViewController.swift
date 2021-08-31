//
//  AuthViewController.swift
//  Spotify
//
//  Created by Amr Hossam on 29/08/2021.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {

    private let webView: WKWebView = {
            let prefs = WKWebpagePreferences()
            prefs.allowsContentJavaScript = true
            let config = WKWebViewConfiguration()
            config.defaultWebpagePreferences = prefs
            let webView = WKWebView(frame: .zero,
                                    configuration: config)
            return webView
        }()
    
    public var completionHandler: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign In"
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        
        guard let url = AuthManager.shared.signInURL else {return}
        webView.load(URLRequest(url: url))
        
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
        webView.navigationDelegate = self
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code"})?.value else {
            return
        }
        
        webView.isHidden = true
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)
            }
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        
    }
    
}
