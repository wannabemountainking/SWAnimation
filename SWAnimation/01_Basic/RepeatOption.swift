//
//  RepeatOption.swift
//  SWAnimation
//
//  Created by YoonieMac on 6/19/26.
//

import SwiftUI

/// 세 가지 반복 에니메이션 옵션을 비교합니다
struct RepeatOption: View {
	@State private var animateHeart: Bool = false // heart 모양 5회 반복
	@State private var animateStar: Bool = false // Star 모양 무한 반복
	@State private var animateCapsule: Bool = false // Capsule 모양 무한 반복
	
    var body: some View {
		ScrollView {
			VStack(spacing: 40) {
				// MARK: - 예제 1: 5회 반복 (Heart)
				TemplateView(
					title: "1. 5회 반복 (Heart)",
					descriptionText: "하트 모양을 5회 반복하며, 자동 반전되어 확대/축소 효과를 보여줍니다",
					content: {
						Image(systemName: "heart.fill")
							.resizable()
							.scaledToFit()
							.frame(width: 100, height: 100)
							.foregroundStyle(.ppink)
							.frame(maxWidth:.infinity, alignment: .center)
							.scaleEffect(animateHeart ? 1.4 : 0.5) // true이면 1.5, false이면 0.8
							.animation(
								.easeInOut(duration: 0.6)
								.repeatCount(5, autoreverses: true),
								value: animateHeart
							)
					} // content
				)// TemplateView
				
				PurpleButton(title: "실행") {
					animateHeart.toggle()
				}
				
				// MARK: - 예제 2. 무한 반복 (Star, autoreverses: false)
				TemplateView(
					title: "2. 무한반복 (Star, No AutoReverse)",
					descriptionText: "별 모양을 무한 반복으로 회전시키며, 반전없이 한 방향으로만 진행합니다",
					content: {
						Image(systemName: "star.fill")
							.resizable()
							.scaledToFit()
							.frame(width: 100, height: 100)
							.foregroundStyle(.accent)
							.frame(maxWidth: .infinity, alignment: .center)
							.rotationEffect(Angle.degrees(animateStar ? 360 : 0))
							.animation(
								animateStar
								? Animation
									.linear(duration: 2)
									.repeatForever(autoreverses: false)
								: .default,
								value: animateStar
							)
					}
				)
				
				PurpleButton(title: animateStar ? "정지" : "실행") {
					animateStar.toggle()
				}
<<<<<<< HEAD
=======
				
				// MARK: - 예제 3. 무한반복 (Capsule, autoreverses: true)
				TemplateView(
					title: "3. 무한반복 (Capsule, Auto-Reverse)",
					descriptionText: "캡슐의 양쪽으로 이동하면서 자동 반전되는 것을 반복합니다",
					content: {
						Capsule()
							.fill(Color.ppurple1)
							.frame(width: 150, height: 50)
							.offset(x: animateCapsule ? 200 : 0, y: 0) // 좌우로 이동하는 효과
							.animation(
								animateCapsule
								? Animation
									.easeInOut(duration: 2)
									.repeatForever(autoreverses: true)
								: .default,
								value: animateCapsule
							)
					}
				)
				
				PurpleButton(title: animateCapsule ? "정지" : "실행") {
					animateCapsule.toggle()
				}
>>>>>>> a249795 (repeat again)
			} //:VSTACK
		} //:SCROLL
    }
}

#Preview {
    RepeatOption()
}
