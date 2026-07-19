//
//  SpringIntro.swift
//  SWAnimation
//
//  Created by yoonie on 7/18/26.
//

import SwiftUI

struct SpringIntro: View {
	@State private var animate: Bool = false // 트리거
	@State private var response: Double = 0.5 // 응답속도: 에니메이션이 얼마나 빠르게 도달하는지 제어
	@State private var dampingFraction: Double = 0.8 // 댐핑비: 진동의 정도를 제어하는 매개변수
	@State private var blendDuration: Double = 0.0 // 블렌드 지속시간: 에니매이션 상태 전환 시 부드러운 연결을 위한 시간
	
    var body: some View {
		TemplateView(
			title: "Spring Animation 기초",
			descriptionText: "슬라이더를 조절하여 Spring Animation을 조정하세요",
			content: {
				VStack(spacing: 40) {
					// MARK: - 에니메이션 대상 영역
					VStack(spacing: 10) {
						ZStack {
							// 배경 원: 에니메이션 기준선
							Circle()
								.stroke(Color.gray.opacity(0.3), lineWidth: 2)
								.frame(width: 150, height: 150)
							// 에니매이션 대상 도형: flame 아이콘
							Image(systemName: "flame.fill")
								.resizable()
								.scaledToFit()
								.frame(width: 80, height: 80)
								.foregroundStyle(
									LinearGradient(
										colors: [Color.orange, Color.red],
										startPoint: .bottom,
										endPoint: .top
									)
								)
								//1. 크기 변화
								.scaleEffect(animate ? 1.0 : 0.3)
								//2. 투명도
								.opacity(animate ? 1.0 : 0.3)
								//3. 회전 에니메이션
								.rotationEffect(Angle.degrees(animate ? 0 : -180))
								//스프링 에니메이션 적용
								.animation(
									.spring(
										response: response,
										dampingFraction: dampingFraction,
										blendDuration: blendDuration
									),
									value: animate
								)
						} //:ZSTACK
						
						// 현재 에니메이션 상태를 텍스트로 표시
						Text(animate ? "에니메이션 활성화" : "에니메이션 대기")
							.font(.caption)
							.foregroundStyle(.ppurple2)
					} //:VSTACK
					
					// MARK: - 매개변수 (response, dampingFraction, blendDuration) 조절 슬라이더
					VStack(spacing: 10) {
						// 1. Response 슬라이더
						SpringParameterSlider(
							title: "Response (응답 속도)",
							range: 0.1...2.0,
							description: "낮을 수록 빠르게 반응합니다",
							color: .accent,
							value: $response
						)
						
						// 2. Damping 슬라이더
						SpringParameterSlider(
							title: "Damping Fraction (댐핑비)",
							range: 0.1...1.0,
							description: "낮을 수록 더 많이 진동합니다",
							color: .ppurple1,
							value: $dampingFraction
						)
						
						// 3. Blend 슬라이더
						SpringParameterSlider(
							title: "Blend Duration (블렌드 시간)",
							range: 0.0...1.0,
							description: "에니메이션 전환의 부드러움을 제어합니다",
							color: .ppink,
							value: $blendDuration
						)
						
					} //:VSTACK
					
				} //:VSTACK
			}
		)
		// PurpleButton 화면 하단에 오버레이로 배치
		.overlay {
			VStack {
				Spacer() // 상단 여백으로 버튼 하단에 고정
				PurpleButton(title: animate ? "리셋" : "에니매이션 시작") {
					animate.toggle()
				}
			} //:VSTACK
			.padding()
		}//: TemplateView
    }
}

// MARK: - 매개변수 슬라이더 컴포넌트
/// Spring 매개변수를 조절하는 재사용 가능한 슬라이더 컴포넌트
struct SpringParameterSlider: View {
	let title: String //  슬라이더 제목
	let range: ClosedRange<Double> // 슬라이더 값 허용 범위
	let description: String // 슬라이더 설명 텍스트
	let color: Color // 슬라이더 테마 칼라
	
	@Binding var value: Double // 바인딩 된 값 양방향 데이터 연결
	
	var body: some View {
		VStack(alignment: .leading, spacing: 19) {
			// 상단: 슬라이더 제목과 현재 값 표시
			HStack {
				// 슬라이더 제목
				Text(title)
					.font(.subheadline)
					.fontWeight(.medium)
					.foregroundStyle(color)
				Spacer() // 제목과 값 사이의 빈공간
				// 현재 값 표시 (소숫점 둘째 짜리까지)
				Text(String(format: "%.2f", value))
					.font(.subheadline)
					.fontWeight(.bold)
					.foregroundStyle(color)
					.padding(.horizontal, 8)
					.padding(.vertical, 4)
					.background(
						// 값 표시 배경: 테마 칼라의 연한 버전
						RoundedRectangle(cornerRadius: 6)
							.fill(color.opacity(0.1))
					)
			} //:HSTACK
			// 중간 : 실제 슬라이더 컨트롤
			Slider(value: $value, in: range)
				.tint(color)
			// 하단 : 슬라이더 기능 설명
			Text(description)
				.font(.caption)
				.foregroundStyle(.gray)
		} //:VSTACK
		.padding()
		.background( // 카드 스타일 배경
			RoundedRectangle(cornerRadius: 12)
				.fill(Color.white.opacity(0.8))
				.shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
		)
		
	}
}

#Preview {
    SpringIntro()
}

#Preview {
	SpringParameterSlider(
		title: "Response (응답속도)",
		range: 0.1...2.0,
		description: "낮을 수록 빠르게 반응합니다",
		color: .accent,
		value: .constant(0.5)
	)
}
