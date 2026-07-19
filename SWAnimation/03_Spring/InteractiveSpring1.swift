//
//  InteractiveSpring.swift
//  SWAnimation
//
//  Created by YoonieMac on 7/19/26.
//

import SwiftUI

// MARK: - 1. Spring VS InteractiveSpring

struct InteractiveSpring1: View {
	
	@State private var isExpanded: Bool = false
	
    var body: some View {
		TemplateView(
			title: "Spring VS Interactive Spring",
			descriptionText: """
				- spring(): 부드럽고 자연스러운 진동, 일반적인 상태 변화에 적합
				- interactiveSpring(): 빠른 반응과 뚜렷한 튕김, 사용자 상호 작용에 최적화
				""",
			content: {
				// Contents
				VStack(spacing: 40) {
					HStack(spacing: 50) {
						// MARK: - Spring()
						VStack(spacing: 10) {
							Text("spring()")
								.font(.headline)
								.foregroundStyle(.ppurple1)
							RoundedRectangle(cornerRadius: 12)
								.fill(Color.ppurple1)
								.frame(width: 80, height: isExpanded ? 300 : 100)
								.animation(.spring(), value: isExpanded)
						} //:VSTACK
						
						// MARK: - InteractiveSpring()
						VStack(spacing: 10) {
							Text("interactiveSpring()")
								.font(.headline)
								.foregroundStyle(.accent)
							RoundedRectangle(cornerRadius: 12)
								.fill(Color.accent)
								.frame(width: 80, height: isExpanded ? 300 : 100)
								.animation(.interpolatingSpring(), value: isExpanded)
						} //:VSTACK
					} //:HSTACK
				} //:VSTACK
			}
		)
		.overlay {
			VStack {
				Spacer()
				PurpleButton(title: isExpanded ? "축소하기" : "확장하기") {
					isExpanded.toggle()
				}
				.padding()
			} //:VSTACK
		}
    }
}

struct InteractiveSpring2: View {
	@State private var isTapped: Bool = false  // 카드 탭 상태 추적 변수
	@State private var isSelected: Bool = false  // 카드가 선택된 상태인지 추적 변수
	
	var body: some View {
		TemplateView(
			title: "Interactive Card Animation",
			descriptionText: "카드를 탭해보세요. interactiveSpring으로 생동감 있는 반응을 경험할 수 있습니다",
			content: {
				VStack(spacing: 30) {
					// MARK: - Interactive Card
					VStack(spacing: 15) {
						// 카드 중앙 하트 아이콘
						Image(systemName: isSelected ? "heart.fill" : "heart")
							.font(.system(size: 50))
							.foregroundStyle(isSelected ? .red : .gray)
						
						// 카드 내 텍스트 정보
						VStack(spacing: 10) {
							// 카드 제목
							Text("Interactive Card")
								.font(.title2)
								.fontWeight(.bold)
								.foregroundStyle(.accent)
							// 상태별 안내 메시지
							Text(isSelected ? "선택됨" : "탭해서 선택하기")
								.font(.headline)
								.foregroundStyle(.gray)
						} //:VSTACK
					} //:VSTACK
					.frame(maxWidth: .infinity) // 전체 너비를 차지하여 카드 중앙 정렬
					.padding()
					.background(
						// 카드 배경 스타일링
						RoundedRectangle(cornerRadius: 20)
							.fill(Color.white)
							.shadow(
								// 선택 상태에 따른 다른 그림자 효과
								color: isSelected ? .red.opacity(0.3) : .black.opacity(0.1),
								radius: isSelected ? 15 : 5, // 선택 시 더 큰 그림자
								x: 0,
								y: isSelected ? 10 : 2 // 선택 시 y축으로 더 깊은 그림자
							)
					)
					.padding()
					
					// MARK: - 에니메이션 효과들
					// 1. Tab 피드백
					.scaleEffect(isTapped ? 0.8 : 1.0)
					// 2. 회전 이팩트
					.rotationEffect(Angle(degrees: isSelected ? 5 : 0))
					// 3. 선택 상태에 따른 크기 변화
					.scaleEffect(isSelected ? 1.2 : 1.0)
					
					// MARK: - 에니메이션 적용
					// 1. isTapped 상태 변화에 따른 빠른 반응 에니메이션
					.animation(
						.interactiveSpring(response: 0.3, dampingFraction: 0.6),
						value: isTapped
					)
					// 2. isSelected 상태 변화에 따른 부드러운 에니메이션
					.animation(
						.interactiveSpring(response: 0.5, dampingFraction: 0.8),
						value: isSelected
					)
					
					// MARK: - 터치 제스처 처리
					.onTapGesture {
						// 1. 즉각적인 탭 피드백
						isTapped = true
						// 2. 텝 피드백 자동 해제 (0.2초 후 자동으로 원래 크기로 복원)
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
							isTapped = false
						}
						// 3. 주요 상태 변경
						isSelected.toggle()
					}
				} //:VSTACK
			},
			notes: """
			- interactiveSpring은 사용자 제스처에 즉각적으로 반응
			- response 값이 낮을 수록 더 빠른 반응성
			- 카드, 버튼 등 상호작용 요소에 최적화됨
			"""
		)
	}
}

#Preview {
    InteractiveSpring1()
}

#Preview("Interactive Card") {
	InteractiveSpring2()
}
