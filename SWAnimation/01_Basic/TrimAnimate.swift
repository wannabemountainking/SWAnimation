//
//  TrimAnimate.swift
//  SWAnimation
//
//  Created by YoonieMac on 6/17/26.
//

import SwiftUI


/// 도형에 trim modifier를 적용한 에니메이션 효과를 3가지 비교합니다
struct TrimAnimate: View {
	
	@State private var change: Bool = false
	
    var body: some View {
		VStack(spacing: 0) {
			TemplateView(
				title: "Trim 에니메이션",
				descriptionText: "Trim modifier를 활용한 도형 변화 효과를 비교합니다",
				content: {
					// MARK: - 1. 원 그리기
					VStack(alignment: .leading, spacing: 10) {
						HStack(spacing: 10) {
							Text("Circle Trim")
								.font(.title2)
								.foregroundStyle(.ppurple1)
							Text(": 전체 원 그리기")
								.font(.footnote)
								.foregroundStyle(.secondary)
						} //:HSTACK
						
						ZStack {
							Circle()
								.trim(from: 0, to: change ? 1 : 0)
								.stroke(Color.accent, style: StrokeStyle(lineWidth: 5, lineJoin: .round))
								.animation(.easeInOut(duration: 1), value: change)
						} //:ZSTACK
						.frame(width: 150, height: 150, alignment: .center)
						
						// MARK: - 2. 부분 노출 효과
						VStack(alignment: .leading, spacing: 10) {
							HStack(spacing: 10) {
								Text("RoundedRectangle Trim")
									.font(.title2)
									.foregroundStyle(.ppurple1)
								Text(": 부분 노출 효과")
									.font(.footnote)
									.foregroundStyle(.secondary)
							} //:HSTACK
							
							ZStack {
								RoundedRectangle(cornerRadius: 20)
									.trim(
										from: change ? 0.3 : 0,
										to: change ? 1 : 0.7
									)
									.stroke(Color.accent, style: StrokeStyle(lineWidth: 5, lineJoin: .round))
									.animation(.easeInOut(duration: 1), value: change)
							} //:ZSTACK
							.frame(width: 250, height: 150, alignment: .center)
						} //:VSTACK
						
						// MARK: - 3. Arc Trim
						VStack(alignment: .leading, spacing: 10) {
							HStack(spacing: 10) {
								Text("Arc Trim")
									.font(.title2)
									.foregroundStyle(.ppurple1)
								Text(": 부분 변경 효과")
									.font(.footnote)
									.foregroundStyle(.secondary)
							} //:HSTACK
							ZStack {
								RoundedRectangle(cornerRadius: 75)
									.trim(
										from: change ? 0.3 : 0,
										to: change ? 0.8 : 0.3
									)
									.stroke(Color.accent, style: StrokeStyle(lineWidth: 5, lineJoin: .round))
									.animation(.easeInOut(duration: 1), value: change)
							} //:ZSTACK
							.frame(width: 150, height: 150, alignment: .center)
						} //:VSTACK
					} //:VSTACK
				},
				notes: "Stroke 와 조합하여 에니메이션 경로 만들기 용도에 적합"
			)
			
			PurpleButton(title: change ? "다시 원위치로" : "에니메이션 시작") {
				change.toggle()
			}
		} //:VSTACK
    }
}

#Preview {
    TrimAnimate()
}
