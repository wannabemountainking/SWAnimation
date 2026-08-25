//
//  RandomUserView.swift
//  SWAnimation
//
//  Created by YoonieMac on 8/24/26.
//

import SwiftUI

/// RandomUser 앱의 메인 화면을 담당하는 루트 뷰
struct RandomUserView: View {
	// MARK: - PROPERTY
	/// 사용자 데이터와 비지니스 로직을 담당하는 ViewModel
	@State private var viewModel: UserViewModel = .init()
	/// 현재 선택된 사용자 정보 (상세화면에서 사용)
	@State private var selectedUser: User? = nil
	/// 상세화면 표시 여부 제어용 트리거
	@State private var showDetail: Bool = false
	/// MGE 용 네임스페이스
	@Namespace private var userNamespace
	
    var body: some View {
		ZStack {
			// Background Color 배경 그라데이션
			LinearGradient(
				colors: [Color.accent, .ppurple1, .ppurple2],
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
			.ignoresSafeArea()
			
			// Content - 조건부 렌더링
			if !showDetail {
				// 사용자 화면 리스트
				VStack(spacing: 10) {
					
					// MARK: - 헤더 영역
					VStack(spacing: 10) {
						Text("Random Users")
							.font(.largeTitle)
							.fontWeight(.bold)
							.foregroundStyle(.white)
						Text("스크롤하면 랜덤 유저를 계속 불러옵니다")
							.font(.caption)
							.foregroundStyle(.white.opacity(0.8))
						
					} //:VSTACK
					.padding(.top, 40) // 상태바 영역 고려한 상단 여백
					.padding(.bottom, 20) // 메인 콘텐츠와의 영역 확보
					
					if viewModel.isLoading && viewModel.users.isEmpty {
						// Loading View
						LoadingView()
						
					} else {
						UserScrollViewWithReader(
							users: viewModel.users,
							namespace: userNamespace,
							isLoadingMore: viewModel.isLoadingMore,
							onTap: { user in
                                // 사용자 카드 텝 시 실행되는 클로저
                                /*
                                 selectUser(user:) 호출 중요성:
                                 - 선택한 사용자의 ID를 lastSelectedUserID 에 저장
                                 - ShouldRestorePosition 플래그를 true로 설정
                                 - 나중에 상세 화면에서 돌아올 때 이 위치로 스크롤 복원
                                 */
                                viewModel.selectUser(user: user)
                                
                                // 상세화면으로 표시할 사용자 정보를 넘겨주는 것
                                selectedUser = user
                                // 조건부 렌더링으로 화면 전환
                                showDetail = true
							},
							onLoadMore: { // 무한 스크롤 로직
								await viewModel.loadMoreUsers()
							},
							onRefresh: { // 리프레시 로직
								await viewModel.refreshUsers()
							}
						)
					}
					
				} //:VSTACK
			} else {
                if let user = selectedUser {
                    // 사용자 상세 화면
                    UserDetailView(
                        user: user,
                        namespace: userNamespace,
                        onClose: {
                            // 리스트 화면으로 전환 시작
                            showDetail = false
                            // 메모리 정리 및 상태 명확화
                            selectedUser = nil
                        }
                    )
                }
			} //:LOOP
			
		} //:ZSTACK
		.task {
			// 중복 로딩 방지: 빈 상태일 때만 초기 로딩 수행
			if viewModel.users.isEmpty {
				await viewModel.loadUsers()
			}
		}
        .animation(.spring, value: showDetail)
    }
}

#Preview {
    RandomUserView()
}
