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
				LogoAnimationView1(isVisible: logoVisible)
				// 타이틀 및 설명 색션
				VStack(spacing: 15) {
					// 메인 타이틀
					Text("Animation Basic")
						.font(.system(size: 40, weight: .bold, design: .rounded))
						.foregroundStyle(.accent)
						.offset(y: titleVisible ? 0 : 30) // Y축 오프셋 에니메이션
						.animation(.easeOut(duration: 1.0), value: titleVisible)
					
					// 설명 텍스트
					Text("기본 에니메이션 기법들을 종합 실습해 보세요")
						.font(.headline)
						.foregroundStyle(.ppurple2)
						.offset(y: descriptionVisible ? 0 : 15)
						.opacity(descriptionVisible ? 1.0 : 0)
						.animation(.easeInOut(duration: 1.0), value: descriptionVisible)
				}
				
				// 기능 카드틀 색션
				VStack(spacing: 15) {
					ForEach(Array(features.enumerated()), id: \.element.id) { index, feature in
						FeatureCardView(feature: feature, index: index, isVisible: cardsVisible)
					}
				}
				
				// 액션 버튼 색션
				VStack(spacing: 15) {
					// 카드가 표시된 후 나타나는 안내 메시지
					if cardsVisible {
						Text("준비가 되셨나요?")
							.font(.caption)
							.foregroundStyle(.ppurple2)
//							.opacity(cardsVisible ? 1.0 : 0)
							.animation(.easeInOut(duration: 0.5).delay(1.0), value: cardsVisible)
					}
					// 에니메이션 완료 후에야 계속 진행 버튼 표시
					if cardsVisible {
						PurpleButton(title: "계속 진행하기") {
							
						}
						.scaleEffect(cardsVisible ? 1.0 : 0.8)
						.opacity(cardsVisible ? 1.0 : 0.0)
						.animation(.easeIn(duration: 0.8).delay(2.0), value: cardsVisible)
					}
				}
				
			} //:VSTACK
			
		} //:ZSTACK
		.onAppear {
			/// 순차적 에니메이션 시작 화면으로 로드시 자동 재생
			startAnimation()
		}
    }
	
	// MARK: - 에니메이션 제어 함수
	/// 순차적 에니메이션 시작 화면 로드시 자동 재생
	private func startAnimation() {
		animationStarted = true // 에니메이션 시작 상태로 변경
		
		// 1 단계 : 로고 에니메이션 -> 즉시 시작
		withAnimation(.easeOut(duration: 1.0)) {
			logoVisible = true
		}
		
		// 2 단계 : 메인 타이틀 0.6초 뒤
		withAnimation(.easeInOut(duration: 1).delay(0.6)) {
			titleVisible = true
		}
		
		// 3 단계 : 설명 텍스트 1.4초 뒤
		withAnimation(.easeInOut(duration: 1).delay(1.4)) {
			descriptionVisible = true
		}
		
		// 4 단계 : 기능 카드들 2.0초 뒤
		withAnimation(.easeInOut(duration: 1)) {
			cardsVisible = true
		}
	}
}


// MARK: - 3. 로고 에니메이션 뷰
struct LogoAnimationView1: View {
	let isVisible: Bool // 로고 표시 여부
	@State private var logoRotating: Bool = false //  로고 회전 상태
	@State private var logoScale: Bool = false // 펄스 효과 상태
	
	var body: some View {
		ZStack {
			// 외부 배경 원 - 큰 펄스 효과
			Circle()
				.fill(Color.accent.opacity(0.1))
				.frame(width: isVisible ? 140 : 60) // 크기 변화로 등장 효과
				.scaleEffect(logoScale ? 1.1 : 1.0) // 역펄스 효과
				.animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: logoScale)
			
			// 내부 배경 원 - 큰 펄스 효과
			Circle()
				.fill(Color.accent.opacity(0.1))
				.frame(width: isVisible ? 110 : 50) // 크기 변화로 등장 효과
				.scaleEffect(logoScale ? 0.9 : 1.0) // 펄스 효과 10%
				.animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(0.3), value: logoScale)
			
			ZStack {
				// 메인 아이콘 - 중심에서 회전 효과
				Image(systemName: "sparkles")
					.font(.system(size: isVisible ? 45 : 10))
					.foregroundStyle(.accent)
					.rotationEffect(.degrees(logoRotating ? 360 : 0)) // 360도 효과
					.animation(.linear(duration: 8).repeatForever(autoreverses: false), value: logoRotating)
				
				// 궤도 아이콘 - 메인 아이콘 주위를 공전
				Image(systemName: "star.fill")
					.font(.system(size: 15))
					.foregroundStyle(.ppurple1)
					.offset(x: 40) // 반지름 40px의 원의 궤도
					.rotationEffect(.degrees(logoRotating ? -360 : 0)) // 역방향 회전(공전효과)
					.animation(.linear(duration: 6).repeatForever(autoreverses: false), value: logoRotating)
			}
		}
		.scaleEffect(isVisible ? 1.0 : 0.3)
		.opacity(isVisible ? 1.0 : 0.0)
		.onAppear {
			// 뷰가 나타나면 회전 및 펄스 에니메이션 시작
			logoRotating = true
			logoScale = true
		}
	}
}

// MARK: - 4. 기능 카드 뷰
struct FeatureCardView: View {
	let feature: FeatureInfo // 카드에 표시할 정보
	let index: Int // 카드 순서 순차 에니메이션 용
	let isVisible: Bool // 카드 표시 여부
	
	var body: some View {
		HStack(spacing: 15) {
			// 아이콘 영역
			ZStack {
				// 아이콘 배경 원
				Circle()
					.fill(Color.accent.opacity(0.1))
					.frame(width: 50, height: 50)
				// SF Symbol 아이콘
				Image(systemName: feature.icon)
					.font(.title3)
					.foregroundStyle(.accent)
			} //:ZSTACK
			
			// 텍스트 컨텐츠 영역
			VStack(alignment: .leading, spacing: 5) {
				// 카드 제목
				Text(feature.title)
					.font(.headline)
					.foregroundStyle(.ppurple1)
				// 카드 설명
				Text(feature.description)
					.font(.subheadline)
					.foregroundStyle(.ppurple2)
			} //:VSTACK
			
			Spacer()
			
		}  //:HSTACK
		.padding()
		.background(
			// 카드 배경 및 스타일링
			RoundedRectangle(cornerRadius: 15)
				.foregroundStyle(Color.white.opacity(0.8)) // 반투명 흰색 배경
				.shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2) // 부드러운 그림자 효과
		)
		.offset(x: isVisible ? 0 : -350) // 왼쪽에서 슬라이드 등장
		.opacity(isVisible ? 1.0 : 0.0) // 투명도 에니메이션
		.animation(.easeInOut(duration: 0.6).delay(Double(index) * 0.5), value: isVisible) // 순차 에니메이션
		.padding(.horizontal)
	}
}

#Preview {
    LandingAnimation1()
}
