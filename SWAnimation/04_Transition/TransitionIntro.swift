//
//  TransitionIntro.swift
//  SWAnimation
//
//  Created by YoonieMac on 8/2/26.
//

import SwiftUI

/// Opacity, Scale, Move Transition 연습 예제
struct TransitionIntro: View {
	@State private var showOpacity: Bool = false // Opacity trigger
	@State private var showScale: Bool = false // Scale Trigger
	@State private var showMove: Bool = false // Move Trigger
	
    var body: some View {
		TemplateView(
			title: "Transition Intro 1",
			descriptionText: "Opacity, Scale, Move 등 기본적인 전환효과를 학습합니다",
			content: {
				VStack(spacing: 30) {
					// MARK: - 1. Opacity Transition
					VStack(spacing: 15) {
						Text("Opacity Transition")
							.font(.title2)
							.fontWeight(.bold)
							.foregroundStyle(.accent)
						Text("가장 기본적인 페이드 인/아웃 효과입니다")
							.font(.caption)
							.foregroundStyle(.secondary)
							.multilineTextAlignment(.center)
						
						// Opacity 전환 제어 버튼
						PurpleButton(
							title: showOpacity ? "페이드 아웃" : "페이드 인",
							action: {
								// withAnimation으로 전환 에니메이션 제어
								withAnimation {
									showOpacity.toggle()
								}
							}
						)
						// Opacity 적용 뷰
						Group {
							if showOpacity {
								RoundedRectangle(cornerRadius: 15)
									.fill(.accent)
									.frame(width: 200, height: 80)
									.overlay {
										Text("부드럽게 나타남")
											.foregroundStyle(.white)
											.fontWeight(.semibold)
									}
								// 중요: Transition 적용
									.transition(.opacity)
							} //:CONDITION
						}
						
					} //:VSTACK
					
					Divider()
					
					// MARK: - 2. Scale Transition
					VStack(spacing: 15) {
						Text("Scale Transition")
							.font(.title2)
							.fontWeight(.bold)
							.foregroundStyle(.accent)
						Text("작은 점에서 시작해서 원래 크기로 확대되는 효과입니다")
							.font(.caption)
							.foregroundStyle(.secondary)
							.multilineTextAlignment(.center)
						
						// Scale 전환 제어 버튼
						PurpleButton(
							title: showScale ? "축소" : "확대",
							action: {
								// withAnimation으로 전환 에니메이션 제어
								withAnimation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.5)) {
									showScale.toggle()
								}
							}
						)
						// Scale 적용 뷰
						Group {
							if showScale {
								VStack(spacing: 10) {
									Image(systemName: "star.fill")
										.font(.system(size: 50))
										.foregroundStyle(.yellow)
									Text("팝업으로 등장!")
										.fontWeight(.medium)
										.foregroundStyle(.accent)
									Text("스프링 에니메이션과 조합하면 더욱 생동감 있는 효과")
										.font(.caption)
										.foregroundStyle(.secondary)
										.multilineTextAlignment(.center)
								} //:VSTACK
								.padding()
								.background(
									RoundedRectangle(cornerRadius: 15)
										.fill(.white)
										.shadow(color: Color.accentColor, radius: 10)
								)
								// Transition 효과 Scale
								.transition(.scale(scale: 0.1))
							}  //:CONDITION
						}
					} //:VSTACK
					
					Divider()
					
					// MARK: - 3. Move Transition 이동 전환
					VStack(spacing: 15) {
						Text("Move Transition")
							.font(.title2)
							.fontWeight(.bold)
							.foregroundStyle(.accent)
						Text("화면 가장자리에서 슬라이드되어 들어오는 효과입니다")
							.font(.caption)
							.foregroundStyle(.secondary)
							.multilineTextAlignment(.center)
						
						// Move 전환 제어 버튼
						PurpleButton(
							title: showMove ? "숨기기" : "슬라이드",
							action: {
								// withAnimation으로 전환 에니메이션 제어
								withAnimation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.5)) {
									showMove.toggle()
								}
							}
						)
						// Move 적용 뷰
						Group {
							if showMove {
								HStack(spacing: 10) {
									Image(systemName: "arrow.up")
										.font(.title)
										.foregroundStyle(.white)
									Text("아래에서 위로 슬라이드")
										.fontWeight(.semibold)
										.foregroundStyle(.white)
								} //:HSTACK
								.padding()
								.background(
									RoundedRectangle(cornerRadius: 15)
										.fill(.accent)
								)
								// Transition move 전환 적용. 밑에서 올라옴
								.transition(.move(edge: .bottom))
							}  //:CONDITION
						}
					} //:VSTACK
				} //:VSTACK
			}
		)
    }
}

// MARK: - Offset, Slide Transition
/// offset, slide Transition
struct TransitionIntro2: View {
	// offset trigger
	@State private var showOffset: Bool =  false
	// slide trigger
	@State private var showSlide: Bool = true
	
	var body: some View {
		TemplateView(
			title: "Transition Intro 2",
			descriptionText: "Offset, Slide 학습합니다",
			content: {
				VStack(spacing: 30) {
					// 1. Offset Transition 시작
					VStack(spacing: 15) {
						Text("Offset Transition")
							.font(.title2)
							.fontWeight(.bold)
							.foregroundStyle(.accent)
						Text("정확한 x, y 좌표를 지정하여 원하는 위치에 등장시킵니다")
							.font(.caption)
							.foregroundStyle(.secondary)
							.multilineTextAlignment(.center)
						
						// Offset 전환 제어 버튼
						PurpleButton(
							title: showOffset ? "사라지기" : "대각선 등장",
							action: {
								// withAnimation으로 전환 에니메이션 제어
								withAnimation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.5)) {
									showOffset.toggle()
								}
							}
						)
						// Offset이 적용되는 뷰
						if showOffset {
							VStack(spacing: 10) {
								Image(systemName: "location.fill")
									.font(.system(size: 40))
									.foregroundStyle(.red)
								Text("대각선에서 등장")
									.fontWeight(.medium)
									.foregroundStyle(.accent)
								Text("x: 200, y: -150 위치에서 시작")
									.font(.caption)
									.foregroundStyle(.secondary)
							} //:VSTACK
							.padding()
							.background(
								RoundedRectangle(cornerRadius: 15)
									.fill(.white)
									.shadow(radius: 5)
							)
							// offset Transition 적용
							.transition(.offset(x: 200, y: -150))
						}//:CONDITIONAL
					} //:VSTACK
					
					Divider()
					
					// 2. Slide Transition 시작
					VStack(spacing: 15) {
						Text("Slide Transition")
							.font(.title2)
							.fontWeight(.bold)
							.foregroundStyle(.accent)
						Text("기본 슬라이드 전환으로 자연스러운 화면 전환을 구현합니다")
							.font(.caption)
							.foregroundStyle(.secondary)
							.multilineTextAlignment(.center)
						
						// Slide 전환 제어 버튼
						PurpleButton(
							title: showSlide ? "슬라이드 아웃" : "슬라이드 인",
							action: {
								// withAnimation으로 전환 에니메이션 제어
								withAnimation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.5)) {
									showSlide.toggle()
								}
							}
						)
						
						// Slide 전환이 적용되는 뷰
						if showSlide {
							VStack(spacing: 15) {
								Image(systemName: "rectangle.portrait.and.arrow.right")
									.font(.system(size: 40))
									.foregroundStyle(.accent)
								Text("자연스러운 슬라이드")
									.font(.headline)
									.foregroundStyle(.accent)
								Text("네비게이션에서 주로 사용되는\n기본 전환 효과입니다")
									.font(.caption)
									.foregroundStyle(.secondary)
									.multilineTextAlignment(.center)
							} //:VSTACK
							.padding()
							.background(
								RoundedRectangle(cornerRadius: 15)
									.stroke(.accent, lineWidth: 2)
							)
							// Slide Transition 적용
							.transition(.slide)
						}//:CONDITIONAL
					} //:VSTACK
				} //:VSTACK
			}
		)
	}
}


#Preview {
    TransitionIntro()
}

#Preview {
	TransitionIntro2()
}
