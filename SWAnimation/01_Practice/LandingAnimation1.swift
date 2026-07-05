//
//  LandingAnimation.swift
//  SWAnimation
//
//  Created by YoonieMac on 7/4/26.
//

import SwiftUI

// MARK: - 1. 데이터 모델 정의
/// 기능 카드에 표시될 정보를 담는 데이터 모델
struct FeatureInfo: Identifiable {
	let id = UUID()          // ID
	let icon: String         // SF symbol 아이콘 이름
	let title: String        // 카드 제목
	let description: String  // 카드 설명
}

// MARK: - MainView
struct LandingAnimation1: View {
	@State private var animationStarted: Bool = false // 전체 에니메이션이 시작되었는 지 여부
	@State private var logoVisible: Bool = false // 로고 표시 여부
	@State private var titleVisible: Bool = false // 메인 타이틀 표시 여부
	@State private var descriptionVisible: Bool = false // 설명 텍스트 표시 여부
	@State private var cardsVisible: Bool = false // 기능 카드들 표시 여부
	
	private let features = [
		FeatureInfo(icon: "timer", title: "Duration", description: "애니메이션 지속 시간"),
		FeatureInfo(icon: "speedometer", title: "Timing Function", description: "ease In ease Out 활용"),
		FeatureInfo(icon: "clock.arrow.circlepath", title: "Delay", description: "순차 에니메이션")
	]
	
    var body: some View {
		ZStack {
			RadialGradient(
				gradient: Gradient(
					colors: [
						Color.white, // 중심 : 흰색
						Color.ppink.opacity(0.5), // 중간
						Color.ppurple1.opacity(0.3) // 외곽
					]
				),
				center: .center, // 그라데이션 중심점: 가운데
				startRadius: 10, // 시작 반지름
				endRadius: 500   // 끝 반지름
			)
				.ignoresSafeArea()
			
			// Content
			VStack(spacing: 30) {
				// 로고 에니메이션 색션
				
				// 타이틀 및 설명 색션
				
				// 기능 카드틀 색션
				
				// 액션 버튼 색션
				
			} //:VSTACK
			
		} //:ZSTACK
    }
}


// MARK: - 3. 로고 에니메이션 뷰
struct

#Preview {
    LandingAnimation1()
}
