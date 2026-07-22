//
//  ElasticMenuView.swift
//  SWAnimation
//
//  Created by YoonieMac on 7/22/26.
//

import SwiftUI


// MARK: - 메뉴 아이템 데이터 모델
/// 각 메뉴 아이템 정보를 담는 구조체
struct MenuItem: Identifiable {
	let id = UUID() // ID 값
	let icon: String // 아이콘 이름
	let title: String // 메뉴 이름
	let subtitle: String // 메뉴 설명
}

// MARK: - Main
struct ElasticMenuView: View {
	// MARK: - Properties
	// 상태값
	/// 메뉴(햄버거)가 열려 있는지 여부를 관리하는 상태값 --> flag 느낌
	@State private var isMenuOpen: Bool = false
	/// 메뉴 아이템들의 표시 여부를 제어하는 상태값
	@State private var showMenuItems: Bool = false
	
	// 메뉴 데이터 배열
	/// 실제 앱에서 표시될 메뉴 아이템들의 데이터
	private let menuItems: [MenuItem] = [
		MenuItem(icon: "house.fill", title: "Home", subtitle: "메인 화면으로"),
		MenuItem(icon: "person.fill", title: "Profile", subtitle: "내 프로필 보기"),
		MenuItem(icon: "heart.fill", title: "Favorites", subtitle: "즐겨찾기 목록"),
		MenuItem(icon: "gear", title: "Settings", subtitle: "앱 설정 변경")
	]
	
    var body: some View {
		ZStack {
			// 초기 화면 (메뉴가 닫힌 상태)
			if !isMenuOpen {  // false 일때
				
			}
			
			// 메뉴 화면
			if isMenuOpen { // true 일때
				
			}
		} //:ZSTACK
		// overlay 를 사용해서 햄버거 버튼을 항상 좌측 최상단에 표시
		.overlay(alignment: .topLeading) {
			
		}
    }
	
	// MARK: - 초기 화면 구성
	
	// MARK: - 메뉴 화면 구성
	
	// MARK: - 메뉴 아이템 리스트
	
	// MARK: - 토글 함수
}

#Preview {
    ElasticMenuView()
}
