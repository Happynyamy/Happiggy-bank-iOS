//
//  AssetImage.swift
//  Happiggy-bank
//
//  Created by sun on 2022/12/21.
//

import UIKit

enum AssetImage {

    // MARK: - Tab bar

    static let homeNormal = UIImage(named: "homeNormal")
    static let homeSelected = UIImage(named: "homeSelected")

    static let listNormal = UIImage(named: "listNormal")
    static let listSelected = UIImage(named: "listSelected")

    static let settingsNormal = UIImage(named: "settingsNormal")
    static let settingsSelected = UIImage(named: "settingsSelected")


    // MARK: - Navigation bar

    static let back = UIImage(named: "back")
    static let checkmark = UIImage(named: "checkmark")
    static let xmark = UIImage(named: "xmark")
    static let next = UIImage(named: "next")


    // MARK: - Settings

    static let alert = UIImage(named: "alert")
    static let customerService = UIImage(named: "customerService")
    static let font = UIImage(named: "font")
    static let version = UIImage(named: "version")


    // MARK: - Characters

    static let bottleMessageCharacter = UIImage(named: "bottleMessageCharacter")
    static let homeCharacter = UIImage(named: "homeCharacter")
    static let homeCharacterInitial = UIImage(named: "homeCharacterInitial")
    

    // MARK: - Notes

    static let greenNote = UIImage(named: "greenNote")
    static let pinkNote = UIImage(named: "pinkNote")
    static let purpleNote = UIImage(named: "purpleNote")
    static let whiteNote = UIImage(named: "whiteNote")
    static let yellowNote = UIImage(named: "yellowNote")

    static func note(ofColor color: NoteColor) -> UIImage? {
        switch color {
        case .white:
            return AssetImage.whiteNote
        case .pink:
            return AssetImage.pinkNote
        case .purple:
            return AssetImage.purpleNote
        case .green:
            return AssetImage.greenNote
        case .yellow:
            return AssetImage.yellowNote
        }
    }


    // MARK: - Note Line

    static let noteLine = UIImage(named: "noteLine")


    // MARK: - Home View

    static let tag = UIImage(named: "tag")
    static let smile = UIImage(named: "smile")
    static let more = UIImage(named: "more")


    // MARK: - Note input view

    static let gallery = UIImage(named: "gallery")
    static let date = UIImage(named: "date")
    static let deleteImage = UIImage(named: "deleteImage")


    // MARK: - Others

    static let fontSelectionExampleBackground = UIImage(named: "fontSelectionExampleBackground")
}
