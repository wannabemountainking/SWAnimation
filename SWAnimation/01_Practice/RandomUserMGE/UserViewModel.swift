//
//  UserViewModel.swift
//  SWAnimation
//
//  Created by YoonieMac on 8/24/26.
//
/*
 API:
 "https://randomuser.me/api"
 
 프로젝트 구조:
 1. Model (User)
 2. NetworkService (UserService)
 3. ViewModel (UserViewModel)
 4. RandomUserView (MainView)
 5. UserDetailView
 6. Components
 
 */

import Foundation
import Observation

@Observable
@MainActor
final class UserViewModel {
	// MARK: - 상태 프로퍼티들
	
	/// 현재 불러올 사용자 목록
	/// private(set): 외부에서 읽기만 가능. 수정이나 삭제는 ViewModel 내부에서만 가능(보통 메서드로 수정, 삭제)
	private(set) var users: [User] = []
	/// 초기 로딩 상태 (앱 시작시 또는 새로고침 시 사용 예정)
	private(set) var isLoading: Bool = false
	/// 추가 로딩 상태(다음 10개를 가져올 때) 무한 스크롤 시
	private(set) var isLoadingMore: Bool = false
	/// 에러 메시지 (옵셔널)
	private(set) var errorMessage: String?
	/// UserService 유일의 인스턴스 불러오기
	private let userService: UserService = .shared
	
	// MARK: - 데이터 로딩 메서드
	func loadUsers() async {
		// 중복 로드 방지 가드문
		guard !isLoading else {return}
		
		// 로딩 상태 시작
		isLoading = true
		errorMessage = nil // 이전 에러 메시지 초기화
		
		do {
			// 네트워크 호출 및 데이터 담기
			let fetchedUsers = try await userService.fetchUsers()
			users = fetchedUsers
		} catch {
			// 네트워크 에러처리 (여기서는 MOCK 데이터 가져오기)
			errorMessage = error.localizedDescription
			users = UserService.mockUsers
		}
		
		// 로딩 완료
		isLoading = false
	}
	
	// MARK: - 무한 스크롤 로직
	
	/// 추가 사용자 데이터를 로드하는 함수
	func loadMoreUsers() async {
		// 중복 로딩 방지
		guard !isLoadingMore else { return }
		// 추가 로딩상태 시작
		isLoadingMore = true
		errorMessage = nil
		
		do {
			// 추가 데이터 로드 (10명 씩 점진적 로딩) - 웹사이트는 fetch에 랜덤하게 결과 나옴
			let moreUsers = try await userService.fetchUsers(count: 10)
			// 기존 데이터에 새 데이터 추가
			users.append(contentsOf: moreUsers)
		} catch {
			errorMessage = error.localizedDescription
		}
		
		// 추가 로딩 완료
		isLoadingMore = false
	}
	
	// MARK: - 전체 데이터 새로고침
	func refreshUsers() async {
		// 기존 데이터 및 상테 초기화
		users = [] // 사용자 목록 비우기
		
		// TODO: - 스크롤 위치 정보 초기화
		
		// 새로운 데이터 로드
		await loadUsers()
	}
}

