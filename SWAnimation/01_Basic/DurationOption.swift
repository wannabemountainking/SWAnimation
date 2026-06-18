//
//  DurationOption.swift
//  SWAnimation
//
//  Created by YoonieMac on 6/18/26.
//

import SwiftUI

/// Duration 은 애니메이션 지속 효과 시간 설정
struct DurationOption: View {
	
	@State private var change: Bool = false
	
    var body: some View {
		VStack(spacing: 40) {
			// MARK: - 기본 에니메이션
			TemplateView(
				title: "에니메이션 지속시간 기본값",
				descriptionText: "별도로 시간을 지정하지 않으면 SwiftUI는 기본값이 0.4 초",
				content: {
					VStack(spacing: 20) {
						Image(systemName: "star.fill")
							.resizable()
							.scaledToFit()
							.frame(width: 100, height: 100)
							.offset(x: change ? 150 : -150, y: 0)
							.animation(.easeInOut, value: change)
						
					} //:VSTACK
				}//: Content
			)//: TemplateView
			
			// MARK: - 3초 지속시간
			TemplateView(
				title: "에니메이션 지속시간 3초",
				descriptionText: "duration을 3초로 저장하면, 효과가 느리게 전개되어 보다 부드러운 전환을 적용할 수 있습니다",
				content: {
					VStack(spacing: 20) {
						Image(systemName: "heart.fill")
							.resizable()
							.scaledToFit()
							.frame(width: 100, height: 100)
							.offset(x: change ? 150 : -150, y: 0)
							.animation(.easeInOut(duration: 3.0), value: change)
						
					} //:VSTACK
				}//: Content
			)//: TemplateView
			
			PurpleButton(title: change ? "에니메이션 초기화" : "에니메이션 실행") {
				change.toggle()
			}
		} //:VSTACK
    }
}

#Preview {
    DurationOption()
}
