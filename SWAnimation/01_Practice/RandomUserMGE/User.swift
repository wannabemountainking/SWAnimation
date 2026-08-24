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
	let name: Name // 이름 정보 (Nested struct)
	let location: Location // 위치 정보 (Nested struct)
	let email: String // 이메일 주소
	let phone: String // 전화번호
	let dob: DateOfBirth // 생년월일 정보 (Nested struct)
	let picture: Picture // 프로필 이미지 정보 (Nested struct)
	
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
	
	// MARK: - 위치 정보 중첩 구조체
	/// 사용자 거주지 정보를 담는 중첩 구조체
	struct Location: Codable {
		let city: String // 도시명
		let state: String // 주 지역명
		let country: String // 국가명
		
		/// 간단히 주소를 조합하는 계산 프로퍼티
		var address: String {
			return "\(city), \(state)"
		}
	}
	
	// MARK: - 생년월일 정보 구조체
	/// 사용자 생년월일과 나이 정보를 담은 구조체
	struct DateOfBirth: Codable {
		let date: String
		let age: Int
	}
	
	// MARK: - 프로필 이미지 정보 구조체
	struct Picture: Codable {
		let large: String // 큰 이미지 URL
		let medium: String // 중간 이미지 URL
		let thumbnail: String // 썸네일이미지 URL
	}
	
	// MARK: - Codable 커스터마이징
	// JSON의 키와 struct의 프로퍼티 이름을 매핑 (id는 빼고 API에서 받아오는 정보)
	enum CodingKeys: String, CodingKey {
		case gender, name, location, email, phone, dob, picture
		// id 는 의도적으로 제외 - 커스텀 디코딩에서 UUID 자동 생성
	}
	
	// MARK: - 커스텀 디코딩 initializer
	/// JSON 파싱 시, 자동으로 호출되어 User 객체를 생성
	init(decoder: Decoder) throws {
		// JSON 데이터 Parsing을 위한 컨테이너 생성
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		self.id = UUID() // SwiftUI 에서 사용할 고유 UUID 생성 (중욧)!!
		
		// JSON 데이터를 Swift 프로퍼티로 매칭( 초기화?? )
		// 구조  SwiftData <= JSON 데이터(CodingKeys)에서 decode해서 넘겨라.. 그런데 왜 container가 필요한가?
		self.gender = try container.decode(String.self, forKey: .gender)
		self.name = try container.decode(Name.self, forKey: .name)
		self.location = try container.decode(Location.self, forKey: .location)
		self.email = try container.decode(String.self, forKey: .email)
		self.phone = try container.decode(String.self, forKey: .phone)
		self.dob = try container.decode(DateOfBirth.self, forKey: .dob)
		self.picture = try container.decode(Picture.self, forKey: .picture)
	}
	
	// MARK: - 수동 생성용 initializer
	/// 프리뷰, 테스트, 목업데이터 생성 시 사용함
	init(gender: String, name: Name, location: Location, email: String, phone: String, dob: DateOfBirth, picture: Picture) {
		self.id = UUID()
		self.gender = gender
		self.name = name
		self.location = location
		self.email = email
		self.phone = phone
		self.dob = dob
		self.picture = picture
	}
	
}
