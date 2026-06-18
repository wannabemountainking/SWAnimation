//
//  DelayOption.swift
//  SWAnimation
//
//  Created by YoonieMac on 6/18/26.
//

import SwiftUI

/// 다선 개의 아이콘이 순차적으로 나타나는 Delay 에니메이션 효과를 나타냅니다
struct DelayOption: View {
	
	@State private var show: Bool = false
	let icons: [(icon: String, color: Color)] = [
		(icon: "star.fill", color: .accent),
		(icon: "heart.fill", color: .ppink),
		(icon: "bolt.fill", color: .yellow),
		(icon: "leaf.fill", color: .green),
		(icon: "sun.max.fill", color: .red)
	]
	
    var body: some View {
		VStack(spacing: 40) {
			TemplateView(
				title: "Delay 에니메이션",
				descriptionText: "각 아이콘이 delay를 이용해 순차적으로 등장합니다",
				content: {
					HStack(spacing: 20) {
						// 첫 번째: star, delay: 0.3
						// 두 번째: heart, delay: 0.6
						// 세 번째: bolt, delay: 0.9
						// 네 번째: leaf, delay: 1.2
						// 다섯번째: sun, delay: 1.5
						
						ForEach(0..<5) { index in
							Image(systemName: icons[index].icon)
								.resizable()
								.scaledToFit()
								.frame(width: 60, height: 60)
								.foregroundStyle(icons[index].color)
								.opacity(show ? 1 : 0)
								.animation(.easeInOut.delay(Double(index) * 0.3), value: show)
						}
					} //:HSTACK
				}//: Content
			)//: TemplateView
			
			PurpleButton(title: show ? "에니메이션 초기화" : "에니메이션 실행") {
				show.toggle()
			}
		} //:VSTACK
    }
}

#Preview {
    DelayOption()
}
