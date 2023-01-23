//
//  BaseViewModel.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 19.01.2023.
//

class BaseViewModel {
    
    let provider: APIClient
    init(provider: APIClient) {
        self.provider = provider
    }
}
