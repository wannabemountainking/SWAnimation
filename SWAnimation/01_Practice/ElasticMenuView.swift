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
	@State private var isMenuOpen: Bool = true
	/// 메뉴 아이템들의 표시 여부를 제어하는 상태값
	@State private var showMenuItems: Bool = true
	
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
				initialScreen
			}
			
			// 메뉴 화면
			if isMenuOpen { // true 일때
				menuScreen
			}
		} //:ZSTACK
		// overlay 를 사용해서 햄버거 버튼을 항상 좌측 최상단에 표시
		.overlay(alignment: .topLeading) {
			hamburgerButton
		}
    }
	
	// MARK: - 초기 화면 구성
	/// 앱의 메인 화면을 담당하는 기본 화면
	private var initialScreen: some View {
		ZStack {
			// Background Color
			Color.white
				.ignoresSafeArea()
			// Content
			VStack(spacing: 30) {
				Spacer()
				
				// 메인 타이틀
				Text("Spring Animation")
					.font(.system(size: 35, weight: .bold, design: .rounded))
					.foregroundStyle(.accent)
				// 서브 타이틀
				Text("Menu")
					.font(.system(size: 25, weight: .bold, design: .rounded))
					.foregroundStyle(.accent)
				// 안내 메세지
				HStack(spacing: 10) {
					Image(systemName: "line.3.horizontal") // 햄버거 아이콘
						.font(.title3)
					Text("매뉴 버튼을 눌러보세요")
						.font(.body)
				} //:HSTACK
				.foregroundStyle(.gray)
				
				Spacer()
			} //:VSTACK
			
		} //:ZSTACK
	}
	
	// MARK: - 메뉴 화면 구성
	/// 메뉴가 열렸을 때 표시되는 전체 메뉴 화면
	private var menuScreen: some View {
		// 배경 그라데이션
		LinearGradient(
			colors: [.accent.opacity(0.9), .accent.opacity(0.7), .accent.opacity(0.5)],
			startPoint: .topLeading,
			endPoint: .bottomTrailing
		)
		.ignoresSafeArea()
		// 배경 확장 에니메이션
		.scaleEffect(isMenuOpen ? 1.0 : 0.1) // 작은 점에서 출발해서 전체 화면으로 크게 나타남
		.overlay {
			// 메뉴 아이템들을 배경 위에 오버레이
			if showMenuItems {
				menuItemList
			}
		}
	}
	
	// MARK: - 메뉴 아이템 리스트
	/// 메뉴 아이템들을 세로로 나열하는 컨테이너
	private var menuItemList: some View {
		Text("메뉴 아이템 리스트")
	}
	
	// MARK: - 햄버거 버튼
	private var hamburgerButton: some View {
		Button {
			//action
			isMenuOpen.toggle()
		} label: {
			ZStack {
				// Background Color
				Circle()
					.fill(isMenuOpen ? .white.opacity(0.2) : .white) // 메뉴 상태에 따른 배경색
					.frame(width: 60, height: 60)
					.shadow(
						color: isMenuOpen ? .clear : .gray.opacity(0.5), // 메뉴 열림 시 그림자 제거
						radius: isMenuOpen ? 0 : 5,
						x: 0,
						y: 2
					)
				// Content
				Image(systemName: isMenuOpen ? "xmark" : "line.3.horizontal")
					.font(.system(size: 25, weight: .medium))
					.foregroundStyle(isMenuOpen ? .white : .accent) // 메뉴 상태에 따른 색상 변화
					.rotationEffect(.degrees(isMenuOpen ? 180 : 0)) // 180도 회전으로 반전 효과
					.animation(
						.spring(response: 0.5, dampingFraction: 0.5),
						value: isMenuOpen
					)
			} //:ZSTACK
		}
		.offset(x: 20, y: 50) // 화면 좌상단 위치 고정
	}
	
	// MARK: - 토글 함수
	
}

// MARK: - 개별 메뉴 아이템 뷰
/// 각각의 메뉴 아이템을 표시하는 개별 뷰
struct MenuItemRow: View {
	
	// 외부에서 받아오는 properties
	let item: MenuItem // 표시할 메뉴 아이템 데이터
	let index: Int  // 배열의 순서 (에니메이션 지연 계산에 활용)
	let isVisible: Bool // 부모에게서 전달받는 표시여부
	
	// 내부 상태 Properties
	/// 이 아이템이 등장 에니메이션을 완료했는 지 여부
	@State private var hasAppeared: Bool = false
	/// 사용자가 이 아이템을 탭하고 있는지 여부
	@State private var isPressed: Bool = false
	
	var body: some View {
		HStack(spacing: 20) {
			// 아이콘 영역
			ZStack {
				// 아이콘 배경 원
				Circle()
					.fill(.white.opacity(0.3))
					.frame(width: 60, height: 60)
				// SF Symbol 아이콘
				Image(systemName: item.icon)
					.font(.system(size: 28, weight: .medium))
					.foregroundStyle(.white)
			} //:ZSTACK
			// 텍스트 영역
			VStack(alignment: .leading, spacing: 5) {
				// 메뉴 제목
				Text(item.title)
					.font(.title2)
					.fontWeight(.bold)
					.foregroundStyle(.white)
				// 메뉴 설명
				Text(item.subtitle)
					.font(.body)
					.foregroundStyle(.white.opacity(0.8))
			} //:VSTACK
			
			Spacer()
			
			// 화살표 아이콘
			Image(systemName: "chevron.right")
				.font(.system(size: 20, weight: .medium))
				.foregroundStyle(.white.opacity(0.5))
		} //:HSTACK
		.padding(.horizontal, 25)
		.padding(.vertical, 20)
		.background(
			RoundedRectangle(cornerRadius: 20)
				.fill(.white.opacity(isPressed ? 0.4 : 0.1)) // 텝 시 배경 진해짐
				.scaleEffect(isPressed ? 1.3 : 1.0) // 텝 시 약간 확대
		)
		// 등장 에니메이션
		// 왼쪽에서 슬라이드 인 효과
		.offset(x: hasAppeared ? 0 : -350) // 왼쪽 350 에서 제자리로
		.opacity(hasAppeared ? 1.0 : 0.0) // 투명에서 불투명으로
		.animation(
			.interpolatingSpring(stiffness: 100, damping: 10)
			.delay(Double(index) + 0.3), // 인덱스 기반 순차적으로 등장(0.3초 씩 지연)
			value: hasAppeared
		)
		.animation(
			.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.5),
			value: isPressed
		) // 텝 피드백 에니메이션
		// 이벤트 처리
		.onAppear {
			hasAppeared = isVisible // 뷰가 나타날 때 등장 상태를 isVisible에 맞춤
		}
		.onChange(of: isVisible) { _, newValue in
			hasAppeared = newValue  // 부모에서 isVisible이 변경되면 등장상태도 업데이트
		}
		.onTapGesture {
			isPressed.toggle()
		}
		.padding(.horizontal)
	}
}

#Preview {
    ElasticMenuView()
}

#Preview("MenuItemRow") {
	ZStack {
		// Background Color
		// 배경 그라데이션
		LinearGradient(
			colors: [.accent.opacity(0.9), .accent.opacity(0.7), .accent.opacity(0.5)],
			startPoint: .topLeading,
			endPoint: .bottomTrailing
		)
		.ignoresSafeArea()
		
		// Content
		MenuItemRow(
			item: MenuItem(icon: "house.fill", title: "Home", subtitle: "메인 화면으로"),
			index: 0,
			isVisible: true
		)
	} //:ZSTACK
}
