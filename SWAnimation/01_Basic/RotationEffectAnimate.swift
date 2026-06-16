//
//  RotationEffectAnimate.swift
//  SWAnimation
//
//  Created by YoonieMac on 6/16/26.
//

import SwiftUI

/// rotation Effect를 사용하여 회전 에니메이션의 다양한 효과를 비교합니다
struct RotationEffectAnimate: View {
	
	@State private var change: Bool = false // Trigger 상태값
	
    var body: some View {
		VStack(spacing: 0) {
			
			TemplateView(
				title: "회전 효과 에니메이션",
				descriptionText: "rotationEffect 를 사용한 회전 에니메이션을 비교합니다",
				content: {
					VStack(spacing: 40) {
						// MARK: - 기본 회전 예제
						VStack(alignment: .leading, spacing: 10) {
							HStack {
								Text("기본 회전")
									.font(.title2)
									.foregroundStyle(.ppurple1)
								Text(": 중심 기준 회전")
									.font(.footnote)
									.foregroundStyle(.secondary)
							} //:HSTACK
							
							RoundedRectangle(cornerRadius: 20)
								.frame(width: 300, height: 200)
								.foregroundStyle(.accent)
								.overlay {
									Text("\(change ? "180°" : "0°")")
										.font(.largeTitle)
										.foregroundStyle(.white)
								}
								.rotationEffect(Angle.degrees(change ? 180 : 0))
								.animation(.easeInOut(duration: 1), value: change)
						} //:VSTACK
						
						// MARK: - 앵커 회전 예제
						VStack(alignment: .leading, spacing: 10) {
							HStack {
								Text("앵커 회전")
									.font(.title2)
									.foregroundStyle(.ppurple1)
								Text(": 하단 우측 기준  90° 회전")
									.font(.footnote)
									.foregroundStyle(.secondary)
							} //:HSTACK
							
							RoundedRectangle(cornerRadius: 20)
								.frame(width: 200, height: 150)
								.foregroundStyle(.accent)
								.overlay {
									Text("\(change ? "360°" : "0°")")
										.font(.largeTitle)
										.foregroundStyle(.white)
								}
								.rotationEffect(
									Angle.degrees(change ? 360 : 0),
									anchor: .topTrailing
								)
								.animation(.easeInOut(duration: 1), value: change)
								.frame(maxWidth: .infinity, alignment: .leading)
						} //:VSTACK
					} //:VSTACK
				}
			)
			
			PurpleButton(
				title: change ? "다시 원위치로" : "에니메이션 실행",
				action: {
					change.toggle()
				}
			)
		} //:VSTACK
    }
}

#Preview {
    RotationEffectAnimate()
}
