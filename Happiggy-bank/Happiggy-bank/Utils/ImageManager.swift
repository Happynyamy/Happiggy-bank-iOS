//
//  ImageManager.swift
//  Happiggy-bank
//
//  Created by sun on 2022/11/26.
//

import UIKit

/// 이미지를 저장하고 불러오는 작업을 수행
final class ImageManager {

    // MARK: - Propereties

    private let fileMananger = FileManager.default


    // MARK: - Functions

    /// 인자로 주어진 값들을 활용해 이미지를 파일 시스템에 저장 후 이미지 아이디 리턴
    func saveImage(_ image: UIImage, noteID: UUID, imageID: String) -> String? {
        let endpoint = self.endPoint(usingNoteID: noteID, imageID: imageID)
        guard let data = image.jpegData(compressionQuality: Metric.compressionQuality),
              let url = self.url(usingEndPoint: endpoint)
        else {
            return nil
        }

        do {
            try data.write(to: url)
        } catch {
            return nil
        }

        return imageID
    }

    /// 인자로 주어진 값들을 경로로 활용해 해당 경로에 이미지가 존재하면 이미지를 리턴
    func image(forNote noteID: UUID, imageURL: String) -> UIImage? {
        let endpoint = self.endPoint(usingNoteID: noteID, imageID: imageURL)
        guard let url = self.url(usingEndPoint: endpoint)
        else {
            return nil
        }

        return UIImage(contentsOfFile: url.path)
    }

    /// 인자로 주어진 값들을 경로로 활용해 해당 경로에 이미지가 존재하면 이미지를 리턴
    @discardableResult
    func deleteImage(forNote noteID: UUID, imageURL: String) -> Bool {
        let endpoint = self.endPoint(usingNoteID: noteID, imageID: imageURL)
        guard let url = self.url(usingEndPoint: endpoint)
        else {
            return false
        }

        do {
            try fileMananger.removeItem(at: url)
        } catch {
            return false
        }

        return true
    }

    /// 경로 중복 방지를 위해 noteID와 imageID를 사용해서 최종 경로를 생성
    private func endPoint(usingNoteID noteID: UUID, imageID: String) -> String {
        let imageID = imageID.replacingOccurrences(of: "/", with: "-")
        return "\(noteID.uuidString)\(imageID)"
    }

    /// endpoint를 최종 경로로 하는 url 생성
    private func url(usingEndPoint endpoint: String) -> URL? {
        guard let documentsDirectory = fileMananger.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            return nil
        }

        return documentsDirectory.appendingPathComponent(endpoint)
    }
}


// MARK: - Constants
fileprivate extension ImageManager {
    enum Metric {
        /// jpeg로 압축 시 압축 품질
        static let compressionQuality: CGFloat = 0.85
    }
}
