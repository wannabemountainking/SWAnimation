//
//  SpringOnboarding.swift
//  SWAnimation
//
//  Created by YoonieMac on 7/22/26.
//

import SwiftUI

struct OnboardingPage: Identifiable {
	let id = UUID()          // 각 페이지 구별 ID 값
	let icon: String         // 아이콘 이름
	let title: String        // 페이지 제목
	let description: String  // 페이지 설명 텍스트
}

struct SpringOnboarding: View {
	// MARK: - Properties
	// 상태값
	/// 현재 보이는 페이지 단계. 1부터 시작
	@State private var step: Int = 1
	/// 온보딩 완료 상태를 나타내는 변수
	@State private var isFinished: Bool = false
	
	// 페이지 데이터 배열
	private let pages = [
		OnboardingPage(
			icon: "cart.fill",
			title: "편리한 쇼핑",
			description: "다양한 제품을 한 곳에서 만나보세요"
		),
		OnboardingPage(
			icon: "shippingbox.fill",
			title: "빠른 배송",
			description: "주문 후 당일 배송으로 기다림 없이 만나 보세요"
		),
		OnboardingPage(
			icon: "creditcard.fill",
			title: "안전한 결제",
			description: "다양한 결제 방법으로 쉽고 편리하게"
		),
	]
	
	
    var body: some View {
		if isFinished {
			// 온보딩 완료 후 메인 앱
			mainAppView
		} else {
			onboardingView
		}
    }
	
	// MARK: - 온보딩 화면 구성
	private var onboardingView: some View {
		ZStack {
			// Background Color
			Color.accent
				.ignoresSafeArea()
			Rectangle()
				.fill(Color.ppurple2)
				.scaleEffect(1.4) // 원래 크기대비 40% 크게 함
				.rotationEffect(.degrees(-15)) // 반시계 방향으로 15도 회전
				.offset(x: -100, y: 300) // 왼쪽 아래 방향으로 이동하여 대각선 배치
			
			// Content
			VStack(spacing: 30) {
				// 헤더 섹션
				VStack(spacing: 15) {
					Text("환영합니다")
						.font(.largeTitle)
						.foregroundStyle(.white)
						.padding(.top)
					Text("쇼핑의 새로운 경험")
						.font(.largeTitle)
						.bold()
						.foregroundStyle(.white)
				} //:VSTACK
				
				// PAGE CONTENT SECTION
				
				/// 화면 너비를 계산하기 위한 GeometryReader 사용
				GeometryReader { geo in
					// HStack 에 모든 페이지를 수평으로 나란히 배치
					HStack(spacing: 0) {
						// 반복문으로 배열 기반 UI 생성
						ForEach(Array(pages.enumerated()), id: \.element.id) {
							index,
							page in
							// 각 개별 페이지 UI 구성 요소
							VStack(spacing: 40) {
								// 대형 아이콘
								Image(systemName: page.icon)
									.font(.system(size: 120)) // 매우 큰 아이콘
									.foregroundStyle(.white)
									.shadow(
										color: .black.opacity(0.1), // 10% 투명도의 검은색 그림자
										radius: 8, // 그림자 블러 효과 8%
										x: 0, // 수평이동 없음 (중앙 위치)
										y: 5 // 수직적으로 4포인트 아래로 그림자 위치
									)
								
								// 페이지 텍스트 컨텐츠
								VStack(spacing: 15) {
									// 페이지 제목
									Text(page.title)
										.font(.title)
										.fontWeight(.bold)
									// 페이지 설명
									Text(page.description)
										.font(.title2)
										.opacity(0.8)
								} //:VSTACK
								.foregroundStyle(.white)
								.multilineTextAlignment(.center)
								.padding()
								
								// 텍스트 등장 에니메이션 (텍스트 한정 에네메이션)
								.animation(
									.interpolatingSpring(
										stiffness: 40, // 스프링 강성
										damping: 7 // 진동 감쇠
									)
									.delay(0.2), // 0.2초 지연
									value: step  // step을 감지해서 에니메이션 시작
								)
								
								
							} //:VSTACK
							// 각 페이지의 너비를 화면 너비와 정확히 동일하게 설정
							// 그래서 한 번에 하나의 페이지만 화면에 보이도록 제어
							.frame(width: geo.size.width)
						} //:LOOP
					} //:HSTACK
					// HStack 전체 설정 및 에니메이션
					// 전체 HStack의 너비 (페이지 수 * 화면 너비 = 3개 화면 모두 하나의 HStack에) 설정
					// 예: 3개 페이지 * 390pt = 1170pt
					.frame(width: geo.size.width * CGFloat(pages.count))
					.frame(maxHeight: .infinity) // 수직으로는 사용 가능한 공간을 최대한 활용
					.padding(.vertical, 60) // 상하 여백으로 콘텐츠와 경계 분리
					
					// 중요✨ : 페이지 전환을 위한 수평 오프셋 계산
					// step 값에 따라 HStack 을 왼쪽으로 이동시켜 페이지 전환 구현
					// step 1: 0pt 첫번째 페이지
					// step 2: -390pt 포인트
					// step 3: -780pt 포인트
					.offset(x: -geo.size.width * CGFloat(step - 1))
					
					// 페이지 전환 에니메이션(화면 전체 이동 에니메이션)
					.animation(.interpolatingSpring(stiffness: 40, damping: 8), value: step)
				} //:GEOMETRY
				
				// 하단 컨트롤 섹션
				VStack(spacing: 20) {
					HStack(spacing: 20) {
						// 1부터 페이지 총 개수까지 범위 반복
						ForEach(1...pages.count, id: \.self) { pageNumber in
							Button {
								//action
								step = pageNumber
							} label: {
								Text("\(pageNumber)")
									.font(.title)
									.foregroundStyle(.white)
									.padding()
									.background(
										Circle()
											.fill(.ppink)
											.shadow(radius: 10)
									)
								// 현재 페이지는 정상크기 1.0, 다른 페이지는 0.5로 축소
									.scaleEffect(step == pageNumber ? 1.0 : 0.6)
							}// : Button

						} //:LOOP
					} //:HSTACK
					// 시작하기 버튼
					Button {
						//action
						isFinished = true
					} label: {
						HStack(spacing: 20) {
							Text("시작하기")
							Image(systemName: "chevron.right")
						} //:HSTACK
						.padding(.horizontal)
						.padding()
						.background(Capsule().fill(.ppink))
						.foregroundStyle(.white)
					}
					// 마지막 페이지에서만 버튼 보이도록 조건부 투명도 설정
					.opacity(step == pages.count ? 1.0 : 0.0)
					.padding(.bottom, 50)
					.animation(.interpolatingSpring(stiffness: 40, damping: 8), value: step)

				} //:VSTACK
				
			} //:VSTACK
			
		} //:ZSTACK
	}
	// MARK: - 메인 앱 화면 구성
	/// 온보딩 완료 후 표싣될 메인 앱 화면
	private var mainAppView: some View {
		VStack(spacing: 10) {
			Text("메인 앱 화면")
				.font(.largeTitle)
				.fontWeight(.bold)
			Text("온보딩이 완료되었습니다")
				.padding()
			
			PurpleButton(title: "온보딩 다시 보기") {
				step = 1 // 첫 페이지로 페이지 리셋
				isFinished = false // 온보딩 화면으로 돌아가기
			}
		} //:VSTACK
	}
	
	
}

#Preview {
    SpringOnboarding()
}
