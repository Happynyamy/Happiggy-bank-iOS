//
//  AssetColor.swift
//  Happiggy-bank
//
//  Created by sun on 2022/12/21.
//

import UIKit

enum AssetColor {

    // MARK: - Main

    static let mainYellow = UIColor(named: "mainYellow")
    static let mainGreen = UIColor(named: "mainGreen")


    // MARK: - Sub

    static let subGrayBG = UIColor(named: "subGrayBG")
    static let subBrown01 = UIColor(named: "subBrown01")
    static let subBrown02 = UIColor(named: "subBrown02")


    // MARK: - Etc

    static let etcTextBox = UIColor(named: "etcTextBox")
    static let etcBorderGray = UIColor(named: "etcBorderGray")
    static let etcAlert = UIColor(named: "etcAlert")


    // MARK: - Note Green

    static let noteGreenBG = UIColor(named: "noteGreenBG")
    static let noteGreenLine = UIColor(named: "noteGreenLine")
    static let noteGreenText = UIColor(named: "noteGreenText")


    // MARK: - Note Pink

    static let notePinkBG = UIColor(named: "notePinkBG")
    static let notePinkLine = UIColor(named: "notePinkLine")
    static let notePinkText = UIColor(named: "notePinkText")


    // MARK: - Note Purple

    static let notePurpleBG = UIColor(named: "notePurpleBG")
    static let notePurpleLine = UIColor(named: "notePurpleLine")
    static let notePurpleText = UIColor(named: "notePurpleText")


    // MARK: - Note white

    static let noteWhiteBG = UIColor(named: "noteWhiteBG")
    static let noteWhiteBG2List = UIColor(named: "noteWhiteBG2List")
    static let noteWhiteLine = UIColor(named: "noteWhiteLine")
    static let noteWhiteText = UIColor(named: "noteWhiteText")


    // MARK: - Note Yellow

    static let noteYellowBG = UIColor(named: "noteYellowBG")
    static let noteYellowLine = UIColor(named: "noteYellowLine")
    static let noteYellowText = UIColor(named: "noteYellowText")


    // MARK: - Functions

    /// 쪽지 색깔에 따른 적절한 배경 색상 리턴
    static func noteBG(for color: NoteColor) -> UIColor? {
        switch color {
        case .white:
            return noteWhiteBG
        case .pink:
            return notePinkBG
        case .purple:
            return notePurpleBG
        case .green:
            return noteGreenBG
        case .yellow:
            return noteYellowBG
        }
    }

    /// 쪽지 색깔에 따른 적절한 테두리 선 색상 리턴
    static func noteLine(for color: NoteColor) -> UIColor? {
        switch color {
        case .white:
            return noteWhiteLine
        case .pink:
            return notePinkLine
        case .purple:
            return notePurpleLine
        case .green:
            return noteGreenLine
        case .yellow:
            return noteYellowLine
        }
    }

    /// 쪽지 색깔에 따른 적절한 글자/강조 색상 리턴
    static func noteText(for color: NoteColor) -> UIColor? {
        switch color {
        case .white:
            return noteWhiteText
        case .pink:
            return notePinkText
        case .purple:
            return notePurpleText
        case .green:
            return noteGreenText
        case .yellow:
            return noteYellowText
        }
    }
}
