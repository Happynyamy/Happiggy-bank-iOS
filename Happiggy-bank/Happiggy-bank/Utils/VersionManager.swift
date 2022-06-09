//
//  VersionManager.swift
//  Happiggy-bank
//
//  Created by sun on 2022/05/13.
//


import UIKit

/// 앱의 버전을 관리
final class VersionManager: VersionChecking {
    
    // MARK: - Properties
    
    /// 싱글턴
    static let shared = VersionManager()
    
    var needsUpdate: OptionalBool {
        guard let installedVersion = self.installedVersion,
              let latestVersion = self.latestVersion
        else { return .nil }
        
        let comparison = installedVersion.compare(latestVersion, options: .numeric)
        return (comparison == .orderedAscending) ? .true : .false
    }
    
    var needsForcedUpdate: Bool {
        guard var installedVersion = self.installedVersion?.compactMap({ Int(String($0)) }),
              let minimumRequiredVersion = self.parseMinimumRequiredVersion(),
              !minimumRequiredVersion.isEmpty
        else { return false }
        
        installedVersion.append(.zero)
        
        for (installed, minimumRequired) in zip(installedVersion, minimumRequiredVersion) {
            guard installed != minimumRequired
            else { continue }
            
            return installed < minimumRequired ? true : false
        }
        
        return false
    }
    
    var installedVersion: String? {
        Bundle.main.infoDictionary?[InfoDictionaryKey.CFBundleShortVersionString] as? String
    }
    
    var latestVersion: String?
    
    /// 강제 업데이트 알림이 이미 있는지 여부
    var forceUpdateAlertIsPresented: Bool = false
    
    /// 진행중인 URLSessionDataTask
    private weak var task: URLSessionDataTask?
    
    /// 앱스토어에서 가져온 앱 정보
    private(set) var appStoreVersionInfo: AppStoreVersionInfo? {
        didSet {
            self.latestVersion = self.appStoreVersionInfo?.version
        }
    }
    
    
    // MARK: - Inits
    
    /// 싱글턴 패턴 사용을 위해 초기화 프라이빗으로 변경
    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    
    // MARK: - @objc
    
    /// 백그라운드로 이동할 때 호출되는 메서드로 앱스토어에서 정보를 가져오는 중이라면 작업을 취소함
    @objc private func appDidEnterBackground() {
        self.task?.cancel()
    }
    
    
    // MARK: - Functions
    
    func checkVersionOnAppStore(completionHandler: ((Bool) -> Void)?) {
        guard let url = URL.AppStore.appInfo
        else { return completionHandler?(false) ?? () }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.processAppInfoRequest(data: data)
            completionHandler?(self.needsForcedUpdate)
        }
        self.task = task
        task.resume()
    }
    
    /// 앱스토어 엔드포인트로부터 받은 데이터를 디코딩
    private func processAppInfoRequest(data: Data?) {
        guard let jsonData = data,
              let lookUpResult = try? JSONDecoder().decode(LookUpResult.self, from: jsonData),
              let appStoreVersionInfo = lookUpResult.results.first
        else { return self.appStoreVersionInfo = nil }
        
        self.appStoreVersionInfo = appStoreVersionInfo
    }
    
    // MARK: 강제 업데이트가 발생하는 경우 *해당 버전부터 이후 모든 버전에 반드시*
    // 1. 릴리즈 노트 "맨 마지막"에
    // 2. "버전 x.x.x" 를 포함한 안내 문구(e.g. 버전 x.x.x 이상을 유지해주새오)가 포함되어야 함
    //    - "버전"이랑 "x.x.x" 사이에 공백 필수
    //    - 이 뒤로는 버전이라는 단어 사용 금지
    // "버전" 이라는 단어를 기준으로 스플릿해서 맨 마지막 문자열을 가져오고,
    // 해당 문자열을 "." 을 기준으로 다시 스플릿해서 파싱해서 숫자만 가져오는 방식이기 때문에
    // 릴리즈 노트 맨 마지막에 2의 문구를 적어주고, 해당 문구의 "버전" 단어 뒤에 최초 숫자는 반드시 지원 버전 숫자여야 함
    //   안되는 예시 (다 막줄이라고 가정)
    //     - 버전 1.2.3 이상을 유지해주새오! 버전 업 필수!!! -> 마지막 "버전" 문자를 기준으로 파싱하기 때문에 금지
    //     - 버전 근데 제 생일은 2월 5일이에요 그리고 1.2.3 이상 유지해주새오! -> "버전" 다음에 쓸데없는 숫자 들어가서 안됨
    /// 릴리즈 노트로부터 최소 지원 버전 파싱
    private func parseMinimumRequiredVersion() -> [Int]? {
        self.appStoreVersionInfo?.releaseNotes
            .components(separatedBy: "버전")
            .last?
            .components(separatedBy: " ")
            .filter { $0.first?.isNumber == true}
            .first?
            .split(separator: ".")
            .compactMap { Int(String($0)) }
    }
}
