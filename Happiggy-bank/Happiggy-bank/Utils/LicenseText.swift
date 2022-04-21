//
//  LicenseText.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/21.
//

import Foundation

// swiftlint:disable line_length
// MARK: - 오픈소스 라이선스 문자열을 따로 관리하기 위한 익스텐션
extension LicenseViewModel {
    
    /// 오픈소스 라이브러리들
    static let openSourceLibraries: [String] = [
        "Then",
        "UPCarouselFlowLayout",
        "Grid.swift"
    ]
    
    /// 하이퍼링크를 걸 문자열과 url 딕셔너리
    static let hyperlinks: [String: String] = [
        "xoul.kr": "http://xoul.kr",
        // TODO: Main 으로 주소 변경
        "Grid.swift from Happiggy": "https://github.com/Happiggy/Happiggy-bank-iOS/blob/develop/Happiggy-bank/Happiggy-bank/Utils/Grid.swift",
        "\"Grid.swift\"":  "https://cs193p.stanford.edu/Fall2017/Grid.swift.zip",
        "CS193p": "https://cs193p.sites.stanford.edu/about-cs193p",
        "CC BY-NC-SA 4.0": "https://creativecommons.org/licenses/by-nc-sa/4.0/"
    ]
    
    /// 오픈소스 라이선스 전문
    static let licenseInformation = """
Then

The MIT License (MIT)

Copyright (c) 2015 Suyeol Jeon (xoul.kr)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.



UPCarouselFlowLayout

The MIT License (MIT)

Copyright (c) 2016 Paul Ulric

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.



Grid.swift

Copyright © 2017 Stanford University. All rights reserved.

Grid.swift from Happiggy is a derivative of "Grid.swift" by CS193p Instructor(Paul Hegarty), Stanford University, used under CC BY-NC-SA 4.0, and is also licensed under CC BY-NC-SA 4.0 by Happiggy.
"""
}
