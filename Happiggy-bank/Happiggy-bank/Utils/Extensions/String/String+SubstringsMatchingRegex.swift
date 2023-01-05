//
//  String+SubstringsMatchingRegex.swift
//  Happiggy-bank
//
//  Created by sun on 2022/12/30.
//

import Foundation

extension String {

    /// 문자열에서 주어진 정규식과 일치하는 부분 문자열을 모두 찾아 배열로 리턴
    /// - Parameter pattern: 찾으려고 하는 정규식
    /// - Returns: 주어진 정규식을 만족하는 모든 부분 문자열의 배열을 리턴. 단, 정규식과 일치하는 부분 문자열이 없는 경우 빈 배열 리턴
    func substringsMatchingRegex(_ pattern: String) -> [String] {
        let regex = try? NSRegularExpression(pattern: pattern)
        let results = regex?.matches(in: self, range: .init(location: .zero, length: self.count))

        return results?.compactMap {
            guard let range = Range($0.range, in: self)
            else {
                return nil
            }

            return String(self[range])
        } ?? []
    }
}
