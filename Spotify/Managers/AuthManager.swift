//
//  AuthManager.swift
//  Spotify
//
//  Created by Amr Hossam on 30/08/2021.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private var refreshingToken: Bool = false
    
    struct Constants {
        static let clientID = "753997d290a24b809b31c8ffa487efc8"
        static let clientSecret = "982f8f13853a4d6692dba62a9c3600b5"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.iosacademy.io"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    
    
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    private init() {}
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    public func exchangeCodeForToken(code: String,completion: @escaping ((Bool) -> Void)) {
        // Get Token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        var components = URLComponents()
        components.queryItems = [
                    URLQueryItem(name: "grant_type",
                                 value: "authorization_code"),
                    URLQueryItem(name: "code",
                                 value: code),
                    URLQueryItem(name: "redirect_uri",
                                 value: Constants.redirectURI),
                ]
        
        var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/x-www-form-urlencoded ",
                                 forHTTPHeaderField: "Content-Type")
                request.httpBody = components.query?.data(using: .utf8)

                let basicToken = Constants.clientID+":"+Constants.clientSecret
                let data = basicToken.data(using: .utf8)
                guard let base64String = data?.base64EncodedString() else {
                    print("Failure to get base64")
                    completion(false)
                    return
                }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        request.httpBody =  components.query?.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                completion(false)
                print("Error: \(error.localizedDescription)")
            }
        }
        task.resume()
        
    }
    
    private var onRefreshBlocks = [((String) -> Void)]()
    
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        if shouldRefreshToken {
            refreshIfNeeded { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        } else if let token = accessToken{
            completion(token)
        }
    }
    
    public func refreshIfNeeded(completion: @escaping (Bool) -> Void) {
        guard !refreshingToken else {
            return
        }
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        guard let refreshToken = self.refreshToken else {
            return
        }
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
                    URLQueryItem(name: "grant_type",
                                 value: "refresh_token"),
                    URLQueryItem(name: "refresh_token",
                                 value: refreshToken),
                ]
        
        var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/x-www-form-urlencoded ",
                                 forHTTPHeaderField: "Content-Type")
                request.httpBody = components.query?.data(using: .utf8)

                let basicToken = Constants.clientID+":"+Constants.clientSecret
                let data = basicToken.data(using: .utf8)
                guard let base64String = data?.base64EncodedString() else {
                    print("Failure to get base64")
                    completion(false)
                    return
                }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        request.httpBody =  components.query?.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("Successfully refreshed")
                self?.onRefreshBlocks.forEach({$0(result.access_token)})
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                completion(false)
                print("Error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    public func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
}
