//
//  PurpleButton.swift
//  SWAnimation
//
//  Created by YoonieMac on 6/13/26.
//

import SwiftUI

/// Purple 색상으로 재사용 가능한 버튼 컴포넌트
struct PurpleButton: View {
	
	let title: String        // 버튼에 표시할 텍스트
	let action: () -> Void   // 버튼이 눌렀을 때 실행할 액션
	
    var body: some View {
		Button(
			action: action,
			label: {
				Text(title)
					.font(.title2)
					.frame(maxWidth: .infinity)
					.padding(.vertical, 10)
			}
		)
		.buttonStyle(.borderedProminent)
		.foregroundStyle(.white)
		.padding(.horizontal)
		.tint(.accent)
		.shadow(radius: 5)
    }
}

#Preview {
	PurpleButton(title: "에니메이션 실행") {
		// 버튼 누를 때 액션 표시
	}
}
