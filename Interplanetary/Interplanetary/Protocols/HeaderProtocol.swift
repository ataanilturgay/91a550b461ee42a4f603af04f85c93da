//
//  HeaderProtocol.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 19.01.2023.
//

protocol HeaderProtocol: CaseIterable & RawRepresentable where Self.RawValue: StringProtocol {

    associatedtype T
    func value() -> String
    static func header(for headerFields: [T]) -> [String: String]
}
