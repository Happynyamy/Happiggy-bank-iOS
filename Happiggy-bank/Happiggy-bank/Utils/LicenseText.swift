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
        "Grid.swift",
        "IBM Plex Sans",
        "Gowun Batang",
        "카페24 써라운드",
        "Gaegu",
        "둘기마요"
        
    ]
    
    /// 하이퍼링크를 걸 문자열과 url 딕셔너리
    static let hyperlinks: [String: String] = [
        "xoul.kr": "http://xoul.kr",
        // TODO: Main 으로 주소 변경
        "Grid.swift from Happiggy": "https://github.com/Happiggy/Happiggy-bank-iOS/blob/develop/Happiggy-bank/Happiggy-bank/Utils/Grid.swift",
        "\"Grid.swift\"":  "https://cs193p.stanford.edu/Fall2017/Grid.swift.zip",
        "CS193p": "https://cs193p.sites.stanford.edu/about-cs193p",
        "CC BY-NC-SA 4.0": "https://creativecommons.org/licenses/by-nc-sa/4.0/",
        "둘기마요": "https://m.blog.naver.com/oters/221300837221",
        "https://github.com/yangheeryu/Gowun-Batang": "https://github.com/yangheeryu/Gowun-Batang",
        "https://fonts.cafe24.com": "https://fonts.cafe24.com"
        
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



둘기마요
둘기마요체를 판매하는 것 외엔 모두 가능합니다.



Gowun Batang

Copyright 2021 The Gowun Batang Project Authors
(https://github.com/yangheeryu/Gowun-Batang)


This Font Software is licensed under the SIL Open Font License, Version 1.1.
This license is copied below, and is also available with a FAQ at:
http://scripts.sil.org/OFL


Gaegu

Copyright 2018 The Gaegu Project Authors

This Font Software is licensed under the SIL Open Font License, Version 1.1.
This license is copied below, and is also available with a FAQ at:
http://scripts.sil.org/OFL


IBM Plex Sans

Copyright © 2017 IBM Corp. with Reserved Font Name "Plex"

This Font Software is licensed under the SIL Open Font License, Version 1.1.
This license is copied below, and is also available with a FAQ at:
http://scripts.sil.org/OFL


카페24 써라운드

Copyright ⓒ Cafe24 Corp. <https://fonts.cafe24.com>

카페24(주)이 제공하는 "카페24 써라운드"는 SIL OPEN FONT LICENSE(Version 1.1)에 따라 사용이 허가됩니다.

"카페24 써라운드"의 지적 재산권은 카페24(주)에 있습니다.
"카페24 써라운드"는 개인 및 기업 사용자를 포함한 모든 사용자에게 무료로 제공되며 자유롭게 수정하고 재배포할 수 있습니다.
단, 글꼴 자체를 유료로 판매하는 것은 금지하며 본 저작권 안내와 라이선스 전문을 포함해서 다른 소프트웨어와 번들하거나 재배포 또는 판매가 가능합니다.
라이선스 전문을 포함하기 어려울 경우, 출처 표기를 권장합니다.
예) 이 페이지에는 카페24(주)이 제공한 "카페24 써라운드"가 적용되어 있습니다.
"카페24 써라운드"가 사용된 인쇄물, 광고물(온라인 포함)의 이미지는 카페24(주)의 프로모션을 위해 활용될 수 있습니다.
이를 원치 않는 사용자는 언제든지 당사에 요청하실 수 있습니다.

정확한 사용 조건은 아래의 SIL OPEN FONT LICENSE 전문을 참고하시기 바랍니다.


-----------------------------------------------------------
SIL OPEN FONT LICENSE Version 1.1 - 26 February 2007
-----------------------------------------------------------

PREAMBLE
The goals of the Open Font License (OFL) are to stimulate worldwide
development of collaborative font projects, to support the font creation
efforts of academic and linguistic communities, and to provide a free and
open framework in which fonts may be shared and improved in partnership
with others.

The OFL allows the licensed fonts to be used, studied, modified and
redistributed freely as long as they are not sold by themselves. The
fonts, including any derivative works, can be bundled, embedded,
redistributed and/or sold with any software provided that any reserved
names are not used by derivative works. The fonts and derivatives,
however, cannot be released under any other type of license. The
requirement for fonts to remain under this license does not apply
to any document created using the fonts or their derivatives.

DEFINITIONS
"Font Software" refers to the set of files released by the Copyright
Holder(s) under this license and clearly marked as such. This may
include source files, build scripts and documentation.

"Reserved Font Name" refers to any names specified as such after the
copyright statement(s).

"Original Version" refers to the collection of Font Software components as
distributed by the Copyright Holder(s).

"Modified Version" refers to any derivative made by adding to, deleting,
or substituting -- in part or in whole -- any of the components of the
Original Version, by changing formats or by porting the Font Software to a
new environment.

"Author" refers to any designer, engineer, programmer, technical
writer or other person who contributed to the Font Software.

PERMISSION & CONDITIONS
Permission is hereby granted, free of charge, to any person obtaining
a copy of the Font Software, to use, study, copy, merge, embed, modify,
redistribute, and sell modified and unmodified copies of the Font
Software, subject to the following conditions:

1) Neither the Font Software nor any of its individual components,
in Original or Modified Versions, may be sold by itself.

2) Original or Modified Versions of the Font Software may be bundled,
redistributed and/or sold with any software, provided that each copy
contains the above copyright notice and this license. These can be
included either as stand-alone text files, human-readable headers or
in the appropriate machine-readable metadata fields within text or
binary files as long as those fields can be easily viewed by the user.

3) No Modified Version of the Font Software may use the Reserved Font
Name(s) unless explicit written permission is granted by the corresponding
Copyright Holder. This restriction only applies to the primary font name as
presented to the users.

4) The name(s) of the Copyright Holder(s) or the Author(s) of the Font
Software shall not be used to promote, endorse or advertise any
Modified Version, except to acknowledge the contribution(s) of the
Copyright Holder(s) and the Author(s) or with their explicit written
permission.

5) The Font Software, modified or unmodified, in part or in whole,
must be distributed entirely under this license, and must not be
distributed under any other license. The requirement for fonts to
remain under this license does not apply to any document created
using the Font Software.

TERMINATION
This license becomes null and void if any of the above conditions are
not met.

DISCLAIMER
THE FONT SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT
OF COPYRIGHT, PATENT, TRADEMARK, OR OTHER RIGHT. IN NO EVENT SHALL THE
COPYRIGHT HOLDER BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
INCLUDING ANY GENERAL, SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL
DAMAGES, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF THE USE OR INABILITY TO USE THE FONT SOFTWARE OR FROM
OTHER DEALINGS IN THE FONT SOFTWARE.
"""
}
