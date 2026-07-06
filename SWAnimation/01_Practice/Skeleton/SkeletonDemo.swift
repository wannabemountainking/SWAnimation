//
//  SkeletonDemo.swift
//  SWAnimation
//
//  Created by YoonieMac on 7/6/26.
//

import SwiftUI

struct SkeletonDemo: View {
	@State private var isLoading: Bool = true
	
    var body: some View {
		TemplateView(
			title: "Skeleton Loading Demo",
			descriptionText: "Extension 방식과 직접 SkeletonView 방식 차이점 비교하기",
			content: {
				ScrollView {
					
					VStack(spacing: 30) {
						// MARK: - Extension View Modifier  사용 예시
						VStack(alignment: .leading, spacing: 15) {
							Text("Extension 방식 .skeleton Modifier")
								.font(.headline)
								.foregroundStyle(.accent)
							
							VStack(spacing: 10) {
								
								// 제목 택스트
								Text("간단 버전")
									.font(.title2)
									.fontWeight(.bold)
									.skeleton(isLoading: isLoading)
								
								// 설명 텍스트
								Text("Extension 을 사용하면 간편하게 skeleton 을 적용할 수 있습니다")
									.font(.body)
									.skeleton(isLoading: isLoading)
								
								// 버튼
								Button {
									//action
								} label: {
									Text("액션 버튼")
								}
								.buttonStyle(.borderedProminent)
								.skeleton(isLoading: isLoading)

							} //:VSTACK
							.padding()
							.background(
								RoundedRectangle(cornerRadius: 10)
									.fill(Color.white)
									.shadow(radius: 3)
							)
						} //:VSTACK
					} //:VSTACK
					
					Spacer()
					
					PurpleButton(title: "새로 고침") {
						reloadContent()
					}
				}
			},
			notes: ""
		)
		.onAppear {
			startLoading()
		}
    }
	
	// MARK: - Helper Method
	
	private func startLoading() {
		Task {
			try await Task.sleep(for: .seconds(2))
			await MainActor.run {
				withAnimation(.easeOut(duration: 0.5)) {
					isLoading = false
				}
			}
		}
	}
	
	private func reloadContent() {
		withAnimation(.easeOut(duration: 0.5)) {
			isLoading = true
		}
		startLoading()
	}
}

#Preview {
    SkeletonDemo()
}
