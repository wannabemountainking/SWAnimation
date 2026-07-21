//
//  InterpolatingSpring2.swift
//  SWAnimation
//
//  Created by YoonieMac on 7/21/26.
//

import SwiftUI

// Mass (질량) : 에니메이션 대상의 무게감을 조절
// initialVelocity (초기 속도) : 에니메이션 시작 시의 속도

/// 데모 타입을 정하는 열거형
enum DemoType: String, CaseIterable {
	case mass = "Mass 비교"
	case velocity = "Initial Velocity 비교"
}

struct InterpolatingSpring2: View {
	
	@State private var currentDemo: DemoType = .mass
	
    var body: some View {
		TemplateView(
			title: "Interpolating 고급 매개 변수",
			descriptionText: "Mass (질량), initialVelocity (초기 속도) 가 에니메이션에 미치는 영향을 비교하세요",
			content: {
				VStack(spacing: 30) {
					
					// MARK: - 데모 타입 선택 세그먼트
					VStack(spacing: 15) {
						Text("매개변수 선택")
							.font(.headline)
							.foregroundStyle(.accent)
						Picker("Demo Type", selection: $currentDemo) {
							ForEach(DemoType.allCases, id: \.self) { demo in
								Text(demo.rawValue)
									.tag(demo)
							} //:LOOP
						}//: PICKER
						.pickerStyle(.segmented)
					} //:VSTACK
					
					// MARK: - 선택된 데모 표시
					Group {
						switch currentDemo {
						case .mass:
							<#code#>
						case .velocity:
							<#code#>
						}
					}
				} //:VSTACK
			}
		)
    }
}

#Preview {
    InterpolatingSpring2()
}
