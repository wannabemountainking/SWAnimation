//
//  BasicMGE1.swift
//  SWAnimation
//
//  Created by YoonieMac on 8/17/26.
//

import SwiftUI

// MARK: - 1. MatchedGeometryEffect 기본 매칭 개념

/// MGE 가장 기본 개념 동작 설명
struct BasicMGE1: View {
	
	// MARK: - @Namespace 선언
	/// @Namespace 뷰를 그룹화하는 뷰 추적용 고유식별자, 동일한 namespace 안에서만 매칭 효과 작동
	@Namespace private var shapeNamespace
	@Namespace private var shapeNamespace2
	
    var body: some View {
		TemplateView(
			title: "MatchedGeometry 기본",
			descriptionText: "동일한 ID를 가진 뷰들이 같은 크기와 위치를 갖게 되는 기본 원리 학습",
			content: {
				VStack(spacing: 40) {
					// MARK: - 일반 뷰
					VStack(spacing: 15) {
						Text("일반 뷰 (각각 다른 크기)")
							.font(.headline)
							.foregroundStyle(.accent)
						
						Text("각 뷰가 고유한 크기를 가집니다")
							.font(.caption)
							.foregroundStyle(.secondary)
						
						HStack(spacing: 20) {
							// 1. 작은 크기 사각형
							RoundedRectangle(cornerRadius: 15)
								.fill(.ppurple1.opacity(0.7))
								.frame(width: 80, height: 80)
								.overlay {
									Text("80 X 80")
										.font(.caption)
										.fontWeight(.semibold)
										.foregroundStyle(.white)
								}
							// 2. 큰 사각형
							RoundedRectangle(cornerRadius: 15)
								.fill(.ppurple2.opacity(0.7))
								.frame(width: 120, height: 60)
								.overlay {
									Text("120 X 60")
										.font(.caption)
										.fontWeight(.semibold)
										.foregroundStyle(.white)
								}
						} //:HSTACK
					} //:VSTACK
					
					Divider()
					
					// MARK: - MGE 사용 예 (매칭된 뷰)
					VStack(spacing: 15) {
						Text("MGE 사용한 뷰 (각각 다른 크기)")
							.font(.headline)
							.foregroundStyle(.accent)
						
						Text("각 뷰가 frame을 공유합니다")
							.font(.caption)
							.foregroundStyle(.secondary)
						
						HStack(spacing: 20) {
							// 1. 작은 크기 사각형
							RoundedRectangle(cornerRadius: 15)
								.fill(.ppurple1.opacity(0.7))
								.frame(width: 80, height: 80)
								.overlay {
									Text("80 X 80")
										.font(.caption)
										.fontWeight(.semibold)
										.foregroundStyle(.white)
								}
							// id: 매칭할 뷰들의 공통 식별자
							// in: 매칭 범위를 제한하는 네임스페이스 아이디
								.matchedGeometryEffect(id: "sharedShape", in: shapeNamespace, anchor: .topLeading)
							// 2. 큰 사각형
							RoundedRectangle(cornerRadius: 15)
								.fill(.ppurple2.opacity(0.7))
								.frame(width: 120, height: 60)
								.overlay {
									Text("120 X 60")
										.font(.caption)
										.fontWeight(.semibold)
										.foregroundStyle(.white)
								}
								.matchedGeometryEffect(id: "sharedShape", in: shapeNamespace, anchor: .topLeading)
						} //:HSTACK
					} //:VSTACK
				} //:VSTACK
			},
			notes: """
				동작 원리:
				- 동일한 ID를 가진 뷰들이 같은 geometry 공유
				- @Namespace로 매칭 범위를 격리하고 추적
				- 기본적으로 size와 position이 모두 매칭됨
				- SwiftUI가 자동으로 최적의 크기와 위치 결정
				"""
		)
    }
}

/// isSource 파라미터를 활용하여 기준되는 뷰를 설정
struct SourceControlView: View {
	// Properties
	/// 어떤 뷰가 source가 될 지를 결정하는 상태 변수
	@State private var yellowIsSource: Bool = true
	@Namespace private var sourceNamespace
	
	var body: some View {
		TemplateView(
			title: "Source 제어하기",
			descriptionText: "isSource 파라미터로 어떤 뷰가 기준이 될 지를 결정할 수 있습니다",
			content: {
				
			},
			notes: """
				
				"""
		)
	}
}

#Preview {
    BasicMGE1()
}

#Preview {
	SourceControlView()
}
