//
//  ColorPulseView.swift
//  SWAnimation
//
//  Created by YoonieMac on 6/18/26.
//

import SwiftUI

struct ColorPulseView: View {
	// 상태 변수로 배경색 토글을 제어
	@State private var animateColor: Bool = false
    var body: some View {
        Circle()
			.frame(width: 150, height: 150) // 원 반지름 75
			// 상테에 따라  pink <-> purple 색상 변경
			.foregroundStyle(animateColor ? .mint : .pink)
			// 배경색 변경 반복 에니메이션 실행
			.animation(
				Animation
					.easeInOut(duration: 1.5)             // 1초 동안 부드럽게 전환
					.repeatForever(autoreverses: true),   // 무한반복 + 색상 반전 효과
				value: animateColor                       // 상태값 변화에 따라 에니메이션 동작
			)
			.onAppear {
				animateColor = true // 뷰가 나타나면 에니메이션 자동 시작
			}
    }
}

#Preview {
    ColorPulseView()
}
