//
//  NewNoteInputViewModel.swift
//  Happiggy-bank
//
//  Created by sun on 2023/03/16.
//

import UIKit

final class NewNoteInputViewModel {

    // MARK: - Properties

    /// 이미지 처리 객체

    /// 임시 쪽지 객체
    let newNote: NewNote

    /// 배경 색상
    var backgroundColor: UIColor? { AssetColor.noteBG(for: self.newNote.color) }

    /// 테두리 줄 색상
    var lineColor: UIColor? { AssetColor.noteLine(for: self.newNote.color) }

    /// 글자 색상
    var textColor: UIColor? {  AssetColor.noteText(for: self.newNote.color) }

    var yearString: String { self.newNote.date.yearString }

    var dateString: String { self.newNote.date.monthDotDayWithDayOfWeekString }

    private let imageMananger = ImageManager()


    // MARK: - Inits

    init(newNote: NewNote) {
        self.newNote = newNote
    }


    // MARK: - Functions

    func saveNote(withImage image: UIImage?, text: String) -> Result<Note, Error> {
        var imageURL: String?

        switch self.saveImageIfNeeded(image) {
        case .failure(let error):
            return .failure(error)
        case .success(let url):
            imageURL = url
        }

        let note = self.makeNewNote(withText: text, imageURL: imageURL)

        switch PersistenceStore.shared.save() {
        case .success:
            return .success(note)
        case .failure(let error):
            PersistenceStore.shared.delete(note)
            if let imageURL {
                self.deleteImage(withImageURL: imageURL)
            }
            return .failure(error)
        }
    }

    /// 이미지가 없는 경우 nil, 있는데 저장에 실패한 경우 에러, 있고 저장에 성공한 경우 경로 리턴
    private func saveImageIfNeeded(_ image: UIImage?) -> Result<String?, Error> {
        guard let image
        else {
            return .success(nil)
        }

        guard image != .error ?? UIImage(),
              let url = self.saveImage(image)
        else {
            return .failure(HBError.imageSaveFailure)
        }

        return .success(url)
    }

    /// 새로운 노트 엔티티를 생성
    private func makeNewNote(withText text: String, imageURL: String?) -> Note {
        Note.create(
            id: self.newNote.id,
            date: self.newNote.date,
            color: self.newNote.color,
            content: text,
            imageURL: imageURL,
            bottle: self.newNote.bottle
        )
    }

    /// 이미지를 저장하고, 성공한 경우 경로 엔드포인트를, 실패한 경우 nil 리턴
    private func saveImage(_ image: UIImage) -> String? {
        guard let imageID = newNote.imageID
        else {
            return nil
        }

        return self.imageMananger.saveImage(image, noteID: newNote.id, imageID: imageID)
    }

    /// 인자로 주어진 경로에 있는 이미지를 삭제
    ///
    /// 삭제에 실패하는 경우 한 번 더 시도하고 리턴
    private func deleteImage(withImageURL imageURL: String) {
        guard !self.imageMananger.deleteImage(forNote: newNote.id, imageURL: imageURL)
        else {
            return
        }

        self.imageMananger.deleteImage(forNote: newNote.id, imageURL: imageURL)
    }
}
