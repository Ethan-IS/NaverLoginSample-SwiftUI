//
//  NaverLogin.swift
//  NaverLoginSample
//
//  Created by Ethan Parker on 10/31/23.
//

import Foundation

import NaverThirdPartyLogin


final public class NaverLogin: NSObject {
    public static let shared = NaverLogin()
    
    static func configure() {
        NaverThirdPartyLoginConnection.getSharedInstance().isInAppOauthEnable = true
        NaverThirdPartyLoginConnection.getSharedInstance().isNaverAppOauthEnable = true
        
        NaverThirdPartyLoginConnection.getSharedInstance().serviceUrlScheme = "naverloginsample"
        NaverThirdPartyLoginConnection.getSharedInstance().consumerKey = "[Developers에 있는 값]"
        NaverThirdPartyLoginConnection.getSharedInstance().consumerSecret = "[Developers에 있는 값]"
        NaverThirdPartyLoginConnection.getSharedInstance().appName = "내 앱의 이름"
        NaverThirdPartyLoginConnection.getSharedInstance().delegate = NaverLogin.shared
    }
    
    private override init() { }
}

// MARK: - Public method
public extension NaverLogin {
    func login() {
        guard !isValidAccessTokenExpireTimeNow else {
            retreiveInfo()
            return
        }
        
        if isInstalledNaver {
            NaverThirdPartyLoginConnection.getSharedInstance().requestThirdPartyLogin()
        } else {
            NaverThirdPartyLoginConnection.getSharedInstance().openAppStoreForNaverApp()
        }
    }
    
    func logout() {
        NaverThirdPartyLoginConnection.getSharedInstance().resetToken()
    }
    
    func unlink() {
        NaverThirdPartyLoginConnection.getSharedInstance().requestDeleteToken()
    }
    
    func receiveAccessToken(_ url: URL) {
        guard url.absoluteString.contains("[내가 Developers에 등록한 URL Scheme]://") else { return }
        NaverThirdPartyLoginConnection.getSharedInstance().receiveAccessToken(url)
    }
    
}

// MARK: - Private variable
private extension NaverLogin {
    var isInstalledNaver: Bool {
        NaverThirdPartyLoginConnection.getSharedInstance().isPossibleToOpenNaverApp()
    }
    
    var isValidAccessTokenExpireTimeNow: Bool {
        NaverThirdPartyLoginConnection.getSharedInstance().isValidAccessTokenExpireTimeNow()
    }
}
 
// MARK: - Private method
private extension NaverLogin {
    func retreiveInfo() {
        guard isValidAccessTokenExpireTimeNow,
            let tokenType = NaverThirdPartyLoginConnection.getSharedInstance().tokenType,
            let accessToken = NaverThirdPartyLoginConnection.getSharedInstance().accessToken else {
            NaverThirdPartyLoginConnection.getSharedInstance().requestAccessTokenWithRefreshToken()
            return
        }
        
        Task {
            do {
                var urlRequest = URLRequest(url: URL(string: "https://openapi.naver.com/v1/nid/me")!)
                urlRequest.httpMethod = "GET"
                urlRequest.allHTTPHeaderFields = ["Authorization": "\(tokenType) \(accessToken)"]
                let (data, _) = try await URLSession.shared.data(for: urlRequest)
                let response = try JSONDecoder().decode(NaverLoginResponse.self, from: data)

            } catch {
                await NaverThirdPartyLoginConnection.getSharedInstance().requestAccessTokenWithRefreshToken()
            }
        }
    }
}

// MARK: - Delegate
extension NaverLogin: NaverThirdPartyLoginConnectionDelegate {
    // Required
    public func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        // 토큰 발급 성공시
        retreiveInfo()
    }
    
    public func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        // 토큰 갱신시
        retreiveInfo()
    }
    
    public func oauth20ConnectionDidFinishDeleteToken() {
        // Logout
    }
    
    public func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        
    }
    
    
    // Optional
    public func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFinishAuthorizationWithResult recieveType: THIRDPARTYLOGIN_RECEIVE_TYPE) {
        
    }
    
    public func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailAuthorizationWithRecieveType recieveType: THIRDPARTYLOGIN_RECEIVE_TYPE) {
        
    }
}
