//
//  PlusShape.swift
//  SWAnimation
//
//  Created by YoonieMac on 7/4/26.
//

import SwiftUI

/// 4개의 사각형이 화면 바깥에서 중앙으로 이동하여 + 모양을 완성하는 예제입니다
struct PlusShape: View {
	
	@State private var change: Bool = false
	
	// Configuration :  에니메이션 간의 이동 거리 설정
	private let finalOffset: CGFloat = 100 // 중앙으로 부터 최종 위치
	private let startOffset: CGFloat = 300 // 초기 위치에서 화면 바깥으로 부터 이동
	
    var body: some View {
		TemplateView(
			title: "플러스 (+) 모양 만들기",
			descriptionText: "네 개의 사각형이 화면 외곽에서 중앙으로 이동하여 플러스(+) 모양을 이룹니다",
			content: {
				ZStack {
					// Background Color 투명한 배경 : 레이아웃 확보용
					Color.clear
						.frame(width: 400, height: 400)
					// Content
					animateRect(x: 0, y: change ? -finalOffset : -startOffset) // 위쪽 사각형
					animateRect(x: 0, y: change ? finalOffset : startOffset)   // 아래쪽 사각형
					animateRect(x: change ? -finalOffset : -startOffset, y: 0) // 왼쪽 사각형
					animateRect(x: change ? finalOffset : startOffset, y: 0)   // 오른쪽 사각형
				} //:ZSTACK
			}
		)
		.background(
			LinearGradient(
				colors: [Color.white, .ppurple2],
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
		)
		.overlay {
			VStack {
				Spacer()
				PurpleButton(title: change ? "다시 원위치로" : "에니메이션 실행") {
					withAnimation(.easeInOut(duration: 1)) {
						change.toggle()
					}
				}
			}
			.padding()
		}
    }
	
	// MARK: - Animated Rectangle
	/// offset과 opacity 를 적용한 사각형을 반환하는 함수
	private func animateRect(x: CGFloat, y: CGFloat) -> some View {
		Rectangle()
			.fill(Color.accent)
			.frame(width: 100, height: 100)
			.offset(x: x, y: y) // 위치 이동
			.opacity(change ? 1 : 0)  // 등장 시 Fade-in
	}
}

#Preview {
    PlusShape()
}
