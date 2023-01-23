//
//  Application.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 18.01.2023.
//

import UIKit

final class Application: NSObject {
    
    static let shared = Application()

    var window: UIWindow?
    var provider: Network?
    var navigator: Navigator
        
    private override init() {
        navigator = Navigator.default
        super.init()
        
        configureProvider()
    }
    
    private func configureProvider() {
        self.provider = NetworkLayer()
    }
    
    func showInitialScreen(in window: UIWindow?) {
        guard let window = window else { return }
        self.window = window
        window.backgroundColor = .white
        
        self.navigator.show(scene: .landing, sender: nil, transition: .root(in: window, animated: false))
    }
    
    func configureNavigationBar() {
        //UINavigationBar.appearance().barTintColor = .gray
        //UINavigationBar.appearance().tintColor = .blue
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.textColor, .font: UIFont.systemFont(ofSize: 16.0)]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.textColor, .font: UIFont.systemFont(ofSize: 32.0)]
        UINavigationBar.appearance().prefersLargeTitles = false
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().shadowImage = UIImage()
    }
}
