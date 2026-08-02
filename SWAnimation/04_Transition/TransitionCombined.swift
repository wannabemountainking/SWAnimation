//
//  TransitionCombined.swift
//  SWAnimation
//
//  Created by YoonieMac on 8/2/26.
//

import SwiftUI

// MARK: - 1. 기본 조합 (2개): Slide + Opacity
/// Slide와 Opacity를 조합한 가장 기본적인 Transition Combined 효과입니다
struct TransitionCombined: View {
	
	@State private var showContent: Bool = false
	
    var body: some View {
		TemplateView(
			title: "기본 조합 효과",
			descriptionText: "Slide와 Opacity를 조합한 기본적인 전환 효과를 학습합니다",
			content: {
				VStack(spacing: 40) {
					
					// 전환 효과 제어 버튼
					PurpleButton(
						title: showContent ? "사라지게 하기" : "나타나게 하기",
						action: {
							withAnimation {
								showContent.toggle()
							}
						}
					)
					
					Spacer()
					
					// 전환 효과 적용 뷰
					if showContent {
						VStack(spacing: 20) {
							// 아이콘
							Image(systemName: "window.shade.closed")
								.font(.system(size: 80))
								.foregroundStyle(.accent)
							// 조합 효과 이름 표시
							Text("Slide + Opacity")
								.font(.title)
								.fontWeight(.bold)
								.foregroundStyle(.accent)
							// 효과 설명
							Text("슬라이드와 페이드가 동시에 적용됩니다")
								.font(.body)
								.foregroundStyle(.secondary)
								.multilineTextAlignment(.center)
							// 설명 추가
							VStack(spacing: 5) {
								Text("1. Slide: Leading -> Trailing  방향 이동")
								Text("2. Opacity: 0.0 -> 1.0 투명도 변화")
							} //:VSTACK
							.font(.caption)
							.foregroundStyle(.ppurple1)
						} //:VSTACK
						.padding(30)
						.background(
							RoundedRectangle(cornerRadius: 20)
								.fill(.white)
								.shadow(color: .accent, radius: 5)
						)
						// 중요!! Transition 효과 넣기
						.transition(
							.slide
								.combined(with: .opacity)
						)
					}//:CONDITIONAL
				} //:VSTACK
			}//: Content
		)//: TemplateView
    } //: BODY
}

// MARK: - 2. 3가지 효과 조합: Scale, Move, Opacity
/// 3가지 서로 다른 전환 효과를 알아보며 조합 순서가 최종 결과에 미치는 영향도 알아봅니다
struct TransitionCombined2: View {
	
	@State private var showThreeTransition: Bool = false
	
	var body: some View {
		TemplateView(
			title: "3가지 효과 Transition",
			descriptionText: "Scale, Move, Opacity를 모두 조합한 복합 Transition 효과를 학습합니다",
			content: {
				VStack(spacing: 40) {
					Spacer()
					
					HStack(spacing: 20) {
						// 트리거 버튼
						Button {
							// Action
							withAnimation(.easeInOut(duration: 1.5)) {
								showThreeTransition.toggle()
							}
						} label: {
							VStack(spacing: 10) {
								Image(systemName: "sparkles")
									.font(.system(size: 30))
									.foregroundStyle(.white)
								Text("3가지 효과")
									.font(.caption)
									.foregroundStyle(.white)
							} //:VSTACK
							.padding()
							.background(
								RoundedRectangle(cornerRadius: 15)
									.fill(.accent.gradient)
							)
						}
						
						// 3가지 효과 조합 Transtion이 적용되는 뷰
						if showThreeTransition {
							VStack(spacing: 15) {
								Image(systemName: "star.circle.fill")
									.font(.system(size: 70))
									.foregroundStyle(.yellow)
								Text("Triple Transition")
									.font(.title2)
									.fontWeight(.bold)
									.foregroundStyle(.accent)
								
								// 각 효과 역할 설명
								VStack(alignment: .leading, spacing: 5) {
									Text("1. Scale: 0.1 -> 1.0 배 (크기 확대)")
										.foregroundStyle(.blue)
									Text("2. Move: 왼쪽에서 이동 (위치 변화)")
										.foregroundStyle(.green)
									Text("3. Opacity: 투명 -> 불투명 (가시성 변화)")
										.foregroundStyle(.accent)
								} //:VSTACK
								.font(.caption)
								.fontWeight(.medium)
								
								Text("세 효과를 동시에 적용하여\n매우 역동적이고 주목도 높은 전환!")
									.font(.caption)
									.foregroundStyle(.secondary)
									.multilineTextAlignment(.center)
							} //:VSTACK
							.padding(25)
							.background(
								RoundedRectangle(cornerRadius: 20)
									.fill(.white)
									.shadow(color: .accent.opacity(0.3), radius: 15)
							)
							// Transition 효과 넣기
							.transition(
//								.scale(scale: 0.1, anchor: .bottomLeading) // 스케일
//								.combined(with: .move(edge: .leading)) // 이동
								.move(edge: .leading)
								.combined(with: .scale(0.1, anchor: .bottomLeading))
								.combined(with: .opacity)
							)
						}//:CONDITIONAL
						
						Spacer()
					} //:HSTACK
					.padding(.horizontal, 20)
				} //:VSTACK
			}
		)
	}
}

#Preview("2가지 Transition") {
    TransitionCombined()
}

#Preview("3가지 Transition") {
	TransitionCombined2()
}
