//
//  FormLabelMGE.swift
//  SWAnimation
//
//  Created by YoonieMac on 8/19/26.
//

import SwiftUI

/// MatchedGeometryEffect 와 Text를 조합하여 폼 라벨 에니메이션 구현
struct FormLabelMGE: View {
	// Properties
	/// 텍스트 필드 입력값
	@State private var email: String = ""
	@State private var password: String = ""
	@State private var name: String = ""
	
	/// 각 텍스트 필드의 포커스 상태 관리
	// @FocusState 는 @State와 유사하지만
	// @State가 내 코드간의 양방향 통로 개통이라면
	// @FocusState는 내 코드(내 입력)와 컴퓨터의 다른 기능(키보드)과 양방향 통로를 개통하는 것입
	@FocusState private var focusedField: FormField?
	
	/// FormField 식별자
	enum FormField {
		case email, password, name
	}
	
	/// 텍스트 전환용 네임스페이스
	@Namespace private var textNamespace
	
    var body: some View {
		TemplateView(
			title: "폼 라벨 에니메이션",
			descriptionText: "텍스트 필드 포커스 시 라벨이 부드럽게 위로 이동하는 Material Design (Floating Label Pattern) 을 구현합니다.",
			content: {
				VStack(spacing: 30) {
					// MARK: - Form Field
					VStack(spacing: 20) {
						// email 폼필드
						animatedTextField(
							title: "이메일",
							text: $email,
							field: .email,
							textID: "emailLabel"
						)
						// password 폼필드
						animatedTextField(
							title: "비밀번호",
							text: $password,
							field: .password,
							textID: "passwordLabel",
							isSecure: true
						)
						// name 폼필드
						animatedTextField(
							title: "이름",
							text: $name,
							field: .name,
							textID: "nameLabel"
						)
						
					} //:VSTACK
					
					// MARK: - Textfield Delete Button
					PurpleButton(
						title: "지우기",
						action: {
							email = ""
							password = ""
							name = ""
							focusedField = nil
						}
					)
					
				} //:VSTACK
			},
			notes: """
				폼 라벨 에니메이션 핵심:
				- MatchedGeometryEffect로 텍스트 위치 부드러운 전환
				- @FocusState 텍스트 필드 포커스 상태 관리
				- Material Design의 Floating Label Pattern 구현
				"""
		)
    }
	
	// MARK: - 에니메이션 텍스트 필드 생성 함수
	/// Floating Label이 있는 TextField 를 생성하는 함수
	private func animatedTextField(
		title: String,
		text: Binding<String>,
		field: FormField,
		textID: String,
		isSecure: Bool = false
	) -> some View {
		
		VStack(spacing: 5) {
			ZStack(alignment: .leading) {
				let floatingShouldBeActive: Bool = focusedField == field || !text.wrappedValue.isEmpty
				let isFieldFocused: Bool = focusedField == field
				// 텍스트 필드 컨테이너
				VStack(spacing: 0) {
					// 상단 라벨 영역(포커스 시 라벨 표시)
					HStack(spacing: 10) {
						if floatingShouldBeActive {
							Text(title)
								.font(.caption)
								.foregroundStyle(.accent)
								.padding(.leading)
								.matchedGeometryEffect(id: textID, in: textNamespace)
						}
						Spacer()
					} //:HSTACK
					.frame(height: floatingShouldBeActive ? 20 : 0)
					
					// 텍스트 필드
					if !isSecure {
						TextField("", text: text)
							.focused($focusedField, equals: field)
							.padding(.leading)
					} else {
						SecureField("", text: text)
							.focused($focusedField, equals: field)
							.padding(.leading)
					}
				} //:VSTACK
				.padding(.vertical, 12)
				.background(
					RoundedRectangle(cornerRadius: 10)
						.stroke(
							isFieldFocused ? Color.accent : Color.secondary.opacity(0.5),
							lineWidth: isFieldFocused ? 3 : 1
						)
				)
				
//				// MARK: - 플레이스홀더 라벨 (비 포커스 시)
				if !floatingShouldBeActive {
					HStack(spacing: 10) {
						Text(title)
							.foregroundStyle(.secondary)
							.matchedGeometryEffect(id: textID, in: textNamespace)
					} //:HSTACK
					.padding(.leading, 20)
				}
			} //:ZSTACK
		} //:VSTACK
		.animation(.spring, value: focusedField)
	}
}

#Preview {
    FormLabelMGE()
}
