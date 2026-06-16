//
//  TextColorsizeAnimationView.swift
//  SWAnimation
//
//  Created by YoonieMac on 6/16/26.
//

import SwiftUI

struct TextColorsizeAnimationView: View {
	
	// 상태 변수: 버튼을 누르면 true/false 로 바뀌며, 뷰 속성이 이에 따라 에니메이션 됩니다.
	@State private var isHighlighted = false
	
    var body: some View {
		VStack(spacing: 20) {
			// MARK: - 에니메이션 대상 텍스트
			Text("에니메이션 텍스트")
				// 텍스트 크기는 상태에 따라 24 또는 40으로 변화합니다.
				// 색상도 상태에 따라 회색 -> 보라색으로 전환됩니다.
				// 크기를 확대/축소하는 효과 (1.2배 확대 vs 원래크기)
				// iOS 16+에서 사용되는 value 기반 에니메이션 적용 방식
				.font(.system(size: isHighlighted ? 40 : 24))
				.foregroundStyle(isHighlighted ? Color.purple : .gray)
				.scaleEffect(isHighlighted ? 1 : 1.2)
				.animation(.easeInOut(duration: 0.5), value: isHighlighted)
			// MARK: - 트리거 버튼
			Button("변경") {
				// 상태를 토글하면 위 텍스트 뷰의 속성이 변화하면서 에니메이션이 발생합니다.
				isHighlighted.toggle()
			}
		} //:VSTACK
    }
}

#Preview {
    TextColorsizeAnimationView()
}
