//
//  User.swift
//  SWAnimation
//
//  Created by YoonieMac on 8/23/26.
//

/*
 API:
 "https://randomuser.me/api"
 
 프로젝트 구조:
 1. Model (User)
 2. NetworkService (UserService)
 3. ViewModel (UserViewModel)
 4. RandomUserView (MainView)
 5. UserDetailView
 6. Components
 
 */

import Foundation

// MARK: - API 응답 레퍼 구조체
/// RandomUser API 응답을 감싸는 레퍼 구조체 (API에서 날아오는 자료 JSON 구조)
/// {
/// 	"result" : [
/// 		{ user1.data },
/// 		{ user2.data },
/// 		...
/// 	]
/// }
struct RandomUserResponse: Codable {
	let results: [User]
}

// MARK: - 메인 사용자 데이터 모델
/// Random API에서 받아오는 사용자 정보를 담는 메인 모델
struct User: Identifiable, Codable {
	var id = UUID() // ForEach 및 스크롤 위치 추적용 고유 식별자
	
	let gender: String // 성별
	let name: Name // 이름 정보 (Nested Structure)
	
	// MARK: - 이름 정보 중첩 구조체
	/// 사용자 이름 정보를 담는 중첩 구조체
	struct Name: Codable {
		let title: String // 호칭
		let first: String // 이름
		let last: String // 성
		
		/// 전체 이름을 조합하는 Computed Property
		var fullName: String {
			return "\(title), \(first) \(last)"
		}
	}
}
