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
						
						// MARK: - 직접 Skeleton View 사용 예제
						VStack(alignment: .leading, spacing: 15) {
							Text("직접 Skeleton 방식")
								.font(.headline)
								.foregroundStyle(.accent)
							
							VStack(spacing: 15) {
								// 프로필 카드
								HStack(spacing: 15) {
									// 아바타 - 정확한 크기 skeleton
									if isLoading {
										SkeletonView(Circle())
											.frame(width: 50, height: 50)
									} else {
										Circle()
											.fill(Color.ppink)
											.frame(width: 50, height: 50)
											.overlay {
												Image(systemName: "person.fill")
													.foregroundStyle(Color.white)
											}
									}
									
									VStack(alignment: .leading, spacing: 5) {
										// 이름 - 정확한 크기 skeleton
										if isLoading {
											SkeletonView(RoundedRectangle(cornerRadius: 5))
												.frame(height: 15)
										} else {
											Text("사용자 이름")
												.font(.headline)
										}
										
										// 직업 - 짧은 Skeleton
										if isLoading {
											SkeletonView(RoundedRectangle(cornerRadius: 5))
												.frame(width: 120, height: 15)
										} else {
											Text("iOS 개발자")
												.font(.subheadline)
												.foregroundStyle(.gray)
										}
									}
									
									Spacer()
									
									// 팔로우 버튼
									if isLoading {
										SkeletonView(RoundedRectangle(cornerRadius: 10))
											.frame(width: 60, height: 30)
									} else {
										Button {
											// action
											
										} label: {
											Text("팔로우")
										}
										.buttonStyle(.borderedProminent)
									}
									
								} //:HSTACK
								.padding()
								.background(
									RoundedRectangle(cornerRadius: 10)
										.fill(Color.white)
										.shadow(radius: 3)
								)
								
							} //:VSTACK
							
						} //:VSTACK
						
					} //:VSTACK
					.padding()
					
					Spacer()
					
					PurpleButton(title: "새로 고침") {
						reloadContent()
					}
				}
			},
			notes: """
				- Extension 방식
					- 장점: 기존 View에 간단하게 적용
					- 단점: 모든 Skeleton 동일한 모양
				- 직접 Skeleton 방식
					- 장점: 정확한 모양 제어
					- 단점: 조건문 필요, 코드가 길어짐
				"""
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
