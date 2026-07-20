//
//  InterpolatingSpring1.swift
//  SWAnimation
//
//  Created by YoonieMac on 7/19/26.
//

import SwiftUI


// MARK: - Spring Damp 방정식
// mẍ + cẋ + kⅹ = 0  (질량 * 가속도) + (스프링상수(강직도) * 이동 거리) + (감쇠계수 * 속도)

// 1. stiffness (강성도) : 얼마나 빠르고 강하게 반응할 지를 결정 (-> 복원력 상수)

// 2. damping (감쇠율) : 진동을 얼마나 빨리 멈출 지를 결정 (-> 저항력 상수)

struct InterpolatingSpring1: View {
	@State private var animate: Bool = false
	
    var body: some View {
		TemplateView(
			title: "Interpolating Spring 비교",
			descriptionText: "stiffness와 damping의 조합으로 다양한 물리적 효과를 만드세요",
			content: {
				// 1. 낮은 stiffness & damping
				InterpolatingSpring1Row(
					title: "낮은 stiffness & 낮은 damping",
					subtitle: "stiffness: 30, damping: 3",
					description: "느리면서 많이 튕기는 효과",
					color: .ppink,
					animate: animate,
					animation: .interpolatingSpring(stiffness: 30, damping: 3)
				)
				// 2. 높은 stiffness, 높은 damping
				InterpolatingSpring1Row(
					title: "높은 stiffness & 높은 damping",
					subtitle: "stiffness: 300, damping: 20",
					description: "빠르게 반응하고 빠르게 멈춤",
					color: .ppurple1,
					animate: animate,
					animation: .interpolatingSpring(stiffness: 300, damping: 20)
				)
				// 3. 중간 밸런스: 최적화
				InterpolatingSpring1Row(
					title: "중간 밸런스",
					subtitle: "stiffness: 150, damping: 15",
					description: "자연스럽고 균형 잡힌 효과",
					color: .ppurple2,
					animate: animate,
					animation: .interpolatingSpring(stiffness:  150, damping: 15)
				)
			}
		)
		.overlay {
			VStack {
				Spacer()
				PurpleButton(
					title: animate ? "리셋" : "에니메이션 시작",
					action: { animate.toggle() }
				)
				.padding()
			} //: VSTACK
		}
    }
}

// MARK: - Spring 에니메이션 행 컴포넌트
struct InterpolatingSpring1Row: View {
	let title: String        // 에니메이션 조합 제목
	let subtitle: String     // stiffness와 damping 값 표시
	let description: String  // 효과에 대한 간단한 설명
	let color: Color         // 에니메이션 대상 색상
	let animate: Bool        // 에니메이션 상태 (외부에서 제어)
	let animation: Animation // 적용할 Spring 에니메이션
	
	var body: some View {
		VStack(alignment: .leading, spacing: 15) {
			// 헤더 정보: 제목, 매개변수 값, 설명
			VStack(alignment: .leading, spacing: 5) {
				// 제목
				Text(title)
					.font(.headline)
					.foregroundStyle(.accent)
				// 매개변수 값 표시
				Text(subtitle)
					.font(.caption)
					.fontWeight(.medium)
					.foregroundStyle(.ppurple2)
				// 효과에 대한 설명
				Text(description)
					.font(.caption)
					.foregroundStyle(.gray)
			} //:VSTACK
			
			//  에니메이션 시각화 영역
			HStack {
				// 움직이는 원
				Circle()
					.fill(color)
					.frame(width: 40, height: 40)
					.offset(x: animate ? 220 : 0)
					.animation(animation, value: animate)
				Spacer()
			} //:HSTACK
			.frame(height: 40)
			.background( // 레일 표시: 에니메이션 경로를 시각적으로 나타냄
				RoundedRectangle(cornerRadius: 5)
					.fill(Color.gray.opacity(0.1))
					.frame(height: 10)
			)
		} //:VSTACK
		.padding()
		.background( // 카드 스타일 배경
			RoundedRectangle(cornerRadius: 15)
				.fill(.white)
				.shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 1)
		)
	}
}

#Preview {
    InterpolatingSpring1()
}

#Preview {
	InterpolatingSpring1Row(
		title: "테스트 로우",
		subtitle: "stiffness: 150, damping: 15",
		description: "자연스럽게 균형 잡힌 효과",
		color: Color.ppurple2,
		animate: false,
		animation: .interpolatingSpring(stiffness: 150, damping: 15)
	)
}
