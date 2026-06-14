//
//  Intro1.swift
//  SWAnimation
//
//  Created by YoonieMac on 6/14/26.
//

import SwiftUI

/// 에니메이션 없는 경우와 있는 경우의 비교
/// 버튼 (Trigger)을 누르면 상태 (@State)가 변화되면서 UI에 반영됨
/// 이 상태 변화에 따라서 에니메이션 적용을 할 수 있음
struct Intro1: View {
	
	@State private var change1: Bool = false // No Animation 상태
	@State private var change2: Bool = false // With Animation 상태
	
    var body: some View {
		TemplateView(
			title: "Animation 있음 VS 없음",
			descriptionText: "에니메이션이 없으면 변화가 즉각적으로 나타나고, 에니메이션이 적용되면 부드럽게 전환되는 것을 확인할 수 있습니다",
			content: {
				
				VStack(alignment: .leading, spacing: 40) {
					// MARK: - No Animation
					Circle()
						.foregroundStyle(Color.accentColor)
						.frame(width: 100, height: 100)
						.offset(x: change1 ? 250 : 0)
					PurpleButton(title: "Change (No Animation)") {
						change1.toggle()
					}
					
					// MARK: - With Animation
					Circle()
						.foregroundStyle(Color.ppurple2)
						.frame(width: 100, height: 100)
						.offset(x: change2 ? 250 : 0)
					PurpleButton(title: "Change (With Animation)") {
						withAnimation(.easeInOut) {
							change2.toggle()
						}
					}
				}
//				.animation(.easeInOut, value: change2)
			},
			notes: nil
		)
    }
}

#Preview {
    Intro1()
}
