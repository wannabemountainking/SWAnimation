//
//  ButtonSwitcherView.swift
//  SWAnimation
//
//  Created by YoonieMac on 8/19/26.
//

import SwiftUI

/// 각 액션 버튼 정보를 담는 구조체
struct ActionButton {
	let id: String
	let title: String
	let icon: String
}

/// MatchedGeometryEffect를 활용한 버튼 위치 전환 구현
struct ButtonSwitcherView: View {
	// Properties
	/// 현재 선택된 버튼 ID
	@State private var selectedActionID: String = "edit"
	/// 버튼 위치 전환용 네임 스페이스
	@Namespace private var buttonNamespace
	/// 액션 버튼 목록
	private let actionButtons = [
		ActionButton(id: "edit", title: "편집", icon: "pencil"),
		ActionButton(id: "share", title: "공유", icon: "square.and.arrow.up"),
		ActionButton(id: "delete", title: "삭제", icon: "trash")
	]
	
    var body: some View {
		TemplateView(
			title: "버튼 위치 스위처",
			descriptionText: "선택된 버튼이 특별한 위치로 이동하며 강조되는 인터페이스를 구현합니다",
			content: {
				VStack(spacing: 40) {
					// MARK: - 선택된 액션 표시 영역
					VStack(spacing: 20) {
						Text("선택된 액션")
							.font(.headline)
							.foregroundStyle(.accent)
						
						// 선택된 버튼이 이동해 올 특별한 영역
						ZStack {
							// Background 영역
							RoundedRectangle(cornerRadius: 20)
								.fill(.accent.opacity(0.1))
								.frame(height: 120)
								.overlay {
									RoundedRectangle(cornerRadius: 20)
										.stroke(Color.accent.opacity(0.3), lineWidth: 2)
										.strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10, 5]))
								}
							
							// 선택된 버튼 영역
							if let selectedButton = actionButtons
								.first(where: { $0.id == selectedActionID }) { //선택된 버튼ID == 배열 버튼ID
								// 선택된 버튼이 이 영역으로 이동
								selectedActionButton(button: selectedButton)
									.matchedGeometryEffect(id: selectedActionID, in: buttonNamespace)
							}
						} //:ZSTACK
					} //:VSTACK
					
					Spacer()
					
					// MARK: - 버튼 선택 영영
					VStack(spacing: 20) {
						Text("액션 버튼을 선택하세요")
							.font(.subheadline)
							.foregroundStyle(.secondary)
						
						
					} //:VSTACK
					
				} //:VSTACK
			},
			notes: """
				
				"""
		)
    }
	
	// MARK: - FUNCTIONS
	/// 특별한 영역에 표시되는 선택된 버튼 (크고 강조된 스타일)
	private func selectedActionButton(button: ActionButton) -> some View {
		VStack(spacing: 15) {
			Image(systemName: button.icon)
				.font(.system(size: 40))
				.foregroundStyle(.white)
			Text(button.title)
				.font(.title2)
				.fontWeight(.semibold)
				.foregroundStyle(.white)
		} //:VSTACK
		.frame(width: 120, height: 100)
		.background(
			RoundedRectangle(cornerRadius: 15)
				.fill(.accent)
				.shadow(color: .accent.opacity(0.3), radius: 10, x: 0, y: 5)
		)
	}
}

#Preview {
    ButtonSwitcherView()
}
