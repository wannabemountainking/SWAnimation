//
//  UserService.swift
//  SWAnimation
//
//  Created by YoonieMac on 8/24/26.
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

/// RandomUser API와 통신하는 네트워크 서비스
@MainActor
final class UserService {
	// MARK: - 싱글톤 패턴
	/// 앱 전체에서 공유하는 단 하나의 UserService 인스턴스
	static let shared: UserService = UserService()
	/// private init 으로 외부에서 UserService 인스턴스 생성 방지
	private init() {}
	
	// MARK: - 네트워크 설정
	
	/// RandomUser API의 기본 URL
	private let baseURL: String = "https://randomuser.me/api"
	
	/// 사용자 데이터를 가져오는 메인 함수 - parameter로 results=10 설정
	func fetchUsers(count: Int = 10) async throws -> [User] {

		/// BaseURL을 URL 객체로 반환
        let url: URL = URL(string: "\(baseURL)?results=\(count)")!
		/// 비동기 네트워크 호출 URLSession.shared.data(from: url)
		let (data, _) = try await URLSession.shared.data(from: url)
		/// JSON 파싱: JSONDecoder를 사용해서 Data를 Swift 객체로 반환 -> 이때 User의 init 작동
		let response = try JSONDecoder().decode(RandomUserResponse.self, from: data)
		/// 파싱된 사용자 배열 반환
		return response.results
	}
	
	// MARK: - 목업 데이터
	/// 프리뷰, 테스트, 네트워크 실패 시 사용할 샘플데이터
	/// static 사용으로 인스턴스 생성 또는 싱글톤(userService.shared) 없이도 접근 가능 -> Preview 사용가능
	static let mockUsers: [User] = [
		User(
			gender: "male",
			name: User.Name(
				title: "Mr",
				first: "Doyoon",
				last: "Kim"
			),
			location: User.Location(
				city: "Seoul",
				state: "Seoul",
				country: "Korea"
			),
			email: "yoonie@gmail.com",
			phone: "+82233455345",
			dob: User.DateOfBirth(date: "1952-06-27T11:20:22.062Z", age: 74),
			picture: User.Picture(
				large: "https://randomuser.me/api/portraits/men/45.jpg",
				medium: "https://randomuser.me/api/portraits/med/men/45.jpg",
				thumbnail: "https://randomuser.me/api/portraits/thumb/men/45.jpg"
			)
		)
	]
}

