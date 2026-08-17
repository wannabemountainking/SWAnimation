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
						} //:HSTACK
					} //:VSTACK
					
				} //:VSTACK
			},
			notes: """
				
				"""
		)
    }
}

#Preview {
    BasicMGE1()
}
