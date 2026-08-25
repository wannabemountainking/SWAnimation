//
//  UserScrollViewWithReader.swift
//  SWAnimation
//
//  Created by yoonie on 8/25/26.
//

import SwiftUI

/// ScrollViewReader 를 사용한 고급 스크롤 관리 컴포넌트
struct UserScrollViewWithReader: View {
	// MARK: - 외부에서 전달받은 데이터와 설정값
	/// 표시할 사용자 목록
	let users: [User]
	/// Hero Animation 을 위한 네임 스페이스
	let namespace: Namespace.ID
	/// 추가 로딩 상태 (무한 스크롤 용)
	let isLoadingMore: Bool
	/// 마지막으로 선택한 User의 ID (위치 복원용) -> 박스 View들 각각에 붙여놓았던 id
//	let lastSelectedUserID: UUID?
	/// 스크롤 위치 복원 할지 말지에 대한 여부
//	let shouldRestorePosition: Bool
	
	// MARK: - 이벤트 핸들러
	/// 사용자 카드 텝 시 실행되는 클로저
	let onTap: (User) -> Void
	/// 추가 데이터 로딩이 필요할 때 실행되는 비동기 클로저
	let onLoadMore: () async -> Void
	/// 스크롤 위치 복원 완료 시 실행되는 클로저
//	let onPositionRestored: () -> Void
	/// Pull-to-Refresh 시 실행되는 비동기 클로저
	let onRefresh: () async -> Void
	
	// MARK: - BODY
    var body: some View {
		ScrollViewReader { proxy in
			ScrollView {
				// 화면에 보이는 항목만 렌더링을 위한 LazyVStack 사용
				LazyVStack(spacing: 0) {
					// 사용자 카드 리스트
					ForEach(users) { user in
						UserCard(
							user: user,
							namespace: namespace,
							onTap: {
								onTap(user) // 상위 뷰에 텝 이벤트 전달
							}
						)
						/*
						 무한 스크롤 트리거 로직 (사용자 카드에 붙여 사용)
						 - 1. 로직 구조: 각 카드가 화면에 나타날 때 .onAppear 실행
						 - 2. 로직 순서: 	1. 마지막 카드인지 확인
										2. 마지막 카드가 나타나면 추가 데이터 로드 시작
						 */
						.onAppear {
							if  user.id == users.last?.id {
								Task {
									await onLoadMore()
								}
							}
						}
					} //:LOOP
					
					// 추가 로딩 인디케이터(loop를 돌아서 users가 늘어나기 직전)
					if isLoadingMore {
						LoadMoreindicator()
					}
				} //:VSTACK
			} //:SCROLL
			.refreshable {
				await onRefresh()
			}
			
			// TODO: - 뷰 등장 시 스크롤 위치 복원
			.onAppear {
				   
			}
			
		}//: READER
		
    }
}

// MARK: - 추가 로딩 인디케이터
struct LoadMoreindicator: View {
	var body: some View {
		HStack(spacing: 15) {
			ProgressView()
				.scaleEffect(0.8)
				.tint(.white)
			Text("Loading More Users")
				.font(.subheadline)
				.foregroundStyle(.white.opacity(0.8))
		} //:HSTACK
		.padding()
		.background(
			Capsule()
				.fill(Color.black.opacity(0.3))
		)
	}
}

#Preview {
	@Previewable @Namespace var namespace
	
	return UserScrollViewWithReader(
		users: Array(repeating: UserService.mockUsers[0], count: 3),
		namespace: namespace,
		isLoadingMore: false,
//		lastSelectedUserID: nil,
//		shouldRestorePosition: false,
		onTap: { _ in },
		onLoadMore: { },
//		onPositionRestored: { },
		onRefresh: { }
		)
	.background {
		LinearGradient(
			colors: [Color.accent, .ppurple1, .ppurple2],
			startPoint: .topLeading,
			endPoint: .bottomTrailing
		)
		.ignoresSafeArea()
	}
}

#Preview("Load more indicator") {
	LoadMoreindicator()
}
