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
					
					ForEach(viewModel.users) { user in
						Text(user.name.fullName)
					}
					
				} //:VSTACK
			} else {
				// 사용자 상세 화면
				UserDetailView()
			} //:LOOP
			
		} //:ZSTACK
		.onAppear {
			Task {
				await viewModel.loadUsers()
			}
		}
    }
}

#Preview {
    RandomUserView()
}
