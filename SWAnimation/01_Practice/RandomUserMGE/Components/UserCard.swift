//
//  UserCard.swift
//  SWAnimation
//
//  Created by YoonieMac on 8/24/26.
//

import SwiftUI

/// 사용자 정보를 표시하는 재사용 가능한 카드 컴포넌트
struct UserCard: View {
	// Properties
	/// 표시할 사용자 정보
	let user: User
	/// MatchedGeometryEffect 사용을 위한 네임스페이스
	let namespace: Namespace.ID
	/// 카드 Tap 시에 실행할 클로저
	let onTap: () -> Void
	
    var body: some View {
		Button {
			// Action
			onTap()
		} label: {
			// 1. 사용할 프로필 이미지
			AsyncImage(
				url: URL(string: user.picture.large),
				content: { image in
					// 이미지 로딩 성공 시
					image
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 80, height: 80)
						.clipShape(Circle())
						.matchedGeometryEffect(id: "\(user.id)-avatar", in: namespace)

				},
				placeholder: {
					// 이미지 로딩 중 또는 실패 시 플레이스 홀더
					Circle()
						.fill(Color.gray.opacity(0.3))
						.frame(width: 80, height: 80)
						.overlay {
							ProgressView()
								.tint(.accent)
						}
						.matchedGeometryEffect(id: "\(user.id)-avatar", in: namespace)
				}
			)
			
			// 2. 사용자 정보
			VStack(spacing: 10) {
				// 사용자 이름
				Text(user.name.fullName)
					.font(.headline)
					.fontWeight(.semibold)
					.foregroundStyle(.white)
					.matchedGeometryEffect(id: "\(user.id)-name", in: namespace)
				// 사용자 위치
				Text(user.location.address)
					.font(.subheadline)
					.foregroundStyle(.white.opacity(0.8))
					.matchedGeometryEffect(id: "\(user.id)-location", in: namespace)

				// 사용자 나이 (세부 정보)
				Text("\(user.dob.age)")
					.font(.caption)
					.foregroundStyle(.white.opacity(0.7))
					.matchedGeometryEffect(id: "\(user.id)-age", in: namespace)
			} //:VSTACK
			
			Spacer()
			
			Image(systemName: "chevron.right")
				.font(.title3)
				.foregroundStyle(.white.opacity(0.6))

		} //:HSTACK
		.padding()
		.background(
			RoundedRectangle(cornerRadius: 20)
				.fill(Color.black.opacity(0.3))
				.matchedGeometryEffect(id: "\(user.id)-background", in: namespace)
		)
		.padding()
		.id(user.id) // 위치 복원 기능용 ID 값임 -> ScrollViewReader 타겟팅 용
    }
}

#Preview {
	@Previewable @Namespace var namespace
	let user = UserService.mockUsers[0]
	UserCard(
		user: user,
		namespace: namespace,
		onTap: { }
	)
}
