//
//  NotificationToastSystem.swift
//  SWAnimation
//
//  Created by YoonieMac on 8/8/26.
//

import SwiftUI
import Observation

// MARK: - 토스트 데이터 모델
/// 각 토스트 알림 정보를 담은 구조체
struct ToastModel: Identifiable, Equatable, Hashable {
	// properties
	let id = UUID() // 각 토스트 인스턴스를 구분하는 ID 값
	let type: ToastType // 토스트 종류 (성공, 에러, 정보)
	let title: String // 토스트의 주요 제목
	var message: String? = nil // 토스트 상세 메시지
	let duration: TimeInterval // 토스트가 자동으로 사라지는 시간
	
	// MARK: - 토스트 타입 Enum
	/// 토스트 종류와 각 종류별 특성을 정의하는 열거형: 모든 케이스 순회
	enum ToastType: CaseIterable {
		case success // 성공 알림
		case warning // 경고 알림
		case error // 에러 알림
		case info // 정보 알림
		
		/// 각 토스트 타입별 테마 색상
		var color: Color {
			/// self는 자기 자신 인스턴스
			/// switch self 사용은 열거형에서 현재 케이스에 따라 다른 값을 return 할 때 사용
			switch self {
			case .success: return .green // 성공 = 그린
			case .warning: return .orange // 경고 = 주황색
			case .error: return .red // 에러 = 빨간색
			case .info: return .blue // 정보 = 파란색
			}
		}
		
		/// 각 토스트 타입별 대표 아이콘
		var icon: String {
			switch self {
			case .success: return "checkmark.circle.fill" // 체크마크
			case .warning: return "exclamationmark.triangle.fill" // 삼각경고
			case .error: return "xmark.circle.fill" // x마크
			case .info: return "info.circle.fill" // i마크
			}
		}
		
		/// 각 토스트 타입별 기본 표시 지속시간
		var defaultDuration: TimeInterval {
			switch self {
			case .success: return 2.0 // 성공 = 2초
			case .warning: return 4.0 // 경고 = 4초
			case .error: return 5.0 // 에러 = 5초
			case .info: return 3.0 // 정보 = 3초
			}
		}
		
		/// 각 포스트 타입별 고유한 transition 효과 기능
		var transition: AnyTransition {
			switch self {
			case .success:
				return .asymmetric(
					insertion: .move(edge: .top).combined(with: .opacity),
					removal: .move(edge: .bottom).combined(with: .opacity)
				)
			case .warning:
				return .asymmetric(
					insertion: .move(edge: .top).combined(with: .scale(scale: 0.8)),
					removal: .move(edge: .leading).combined(with: .opacity)
				)
			case .error:
				return .asymmetric(
					insertion: .move(edge: .top).combined(with: .scale(scale: 0.5)),
					removal: .move(edge: .trailing).combined(with: .opacity)
				)
			case .info:
				return .asymmetric(
					insertion: .move(edge: .top),
					removal: .move(edge: .bottom).combined(with: .opacity)
				)
			}
		}
		
		/// 각 타입의 특성을 설명하는 텍스트
		var description: String {
			switch self {
			case .success: return "성공 알림"
			case .warning: return "주의 알림"
			case .error: return "에러 알림"
			case .info: return "정보 알림"
			}
		}
	}
}

// MARK: - 토스트 메니저 (ViewModel)
@Observable
final class ToastManager {
	// MARK: - Properties
	/// 현재 화면에 표시 중인 토스트들의 배열
	var activeToasts: [ToastModel] = []
	/// 각 토스트별로 설정된 자동 사라짐 타이머들을 관리하는 Dictionary
	private var timers: [UUID: Timer] = [:]
	/// 동시에 표시 가능한 최대 토스트 개수
	private let maxToasts: Int = 3
	
	// MARK: - Methods
	/// 새로운 토스트를 화면에 표시하는 메인 함수
	func showToast(
		type: ToastModel.ToastType,
		title: String,
		message: String? = nil,
		duration: TimeInterval? = nil
	) {
		// 1. 새로운 토스트 인스턴스 생성
		let toast = ToastModel(
			type: type,
			title: title,
			message: message,
			duration: duration ?? type.defaultDuration
		)
		// 2. 최대 개수 제한 로직
		// 최대 개수가 같거나 넘어갈 경우(배열이 넘치면) 기존에 가장 먼저 만든 토스트 메시지를 수동으로 제거
		if activeToasts.count >= maxToasts {
			if let oldestToast = activeToasts.first {
				dismissToast(oldestToast)
			}
		}
		// 3. 새 토스트를 배열에 추가
		withAnimation(.spring) {
			activeToasts.append(toast)
		}
		
		// 4. 토스트 자동 사라짐 타이머 설정(타이머 생성)
		let timer = Timer.scheduledTimer(withTimeInterval: toast.duration, repeats: false) { _ in
			// UI 업데이트이므로 반드시 메인쓰레드에서 !!
			DispatchQueue.main.async {
				self.dismissToast(toast)
			}
		}
		
		// 5. 생성된 타이머를 딕셔너리에 저장 (나중에 수동 해제를 위해)
		timers[toast.id] = timer
	}
	
	/// 특정 토스트를 수동으로 제거하는 함수
	func dismissToast(_ toast: ToastModel) {
		// 메모리 정리: 해당 토스트의 타이머를 찾아서 해제
		timers[toast.id]?.invalidate() // 타이머 중단
		timers.removeValue(forKey: toast.id) // 딕셔너리에서 제거
		
		// 에니메이션과 함께 토스트를 배열에서 제거
		withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
			activeToasts.removeAll(where: { $0.id == toast.id })
		}
	}
	
	/// 화면에 표시된 모든 토스트를 한 번에 제거하는 함수
	func dismissAllToast() {
		// 모든 타이머 정리
		// 1. 모든 타이머 invalidate()
		timers.values.forEach { timer in
			timer.invalidate()
		}
		// 2. timers를 메모리에서 삭제
		timers.removeAll()
		
		// 모든 토스트 제거
		withAnimation(.spring) {
			activeToasts.removeAll()
		}
	}
}

// MARK: - 메인 토스트 시스템 뷰
/// 토스트 시스템 전체를 구현하는 메인 뷰
struct NotificationToastSystem: View {
	/// 토스트 메니저 Instance
	@State private var toastManager: ToastManager = .init()
	
    var body: some View {
		ZStack {
			mainContent
			toastOverlay
		}
    }
	
	// MARK: - 메인 컨텐츠 (데모용 화면)
	/// 토스트 시스템을 테스트할 수 있는 데모 확인
	private var mainContent: some View {
		NavigationStack {
			VStack(spacing: 30) {
				
				Spacer()
				
				// MARK: - 토스트 타입별 테스트 버튼 그룹
				VStack(spacing: 20) {
					// 성공 토스트 버튼
					Button {
						// Action
						toastManager.showToast(
							type: .success,
							title: "성공!",
							message: "파일이 성공적으로 저장되었습니다"
						)
					} label: {
						ToastDemoButton(
							title: "Success Toast",
							icon: "checkmark.circle.fill",
							color: .green
						)
					}
					// 경고 토스트 버튼
					Button {
						// Action
						toastManager.showToast(
							type: .warning,
							title: "주의 필요"
						)
					} label: {
						ToastDemoButton(
							title: "Warning Toast",
							icon: "exclamationmark.triangle.fill",
							color: .orange
						)
					}
					// 에러 토스트 버튼
					Button {
						// Action
						toastManager.showToast(
							type: .error,
							title: "오류 발생",
							message: "네트워크 연결을 확인하고 다시 시도해 주세요"
						)
					} label: {
						ToastDemoButton(
							title: "Error Toast",
							icon: "xmark.circle.fill",
							color: .red
						)
					}
					// 인포 토스트 버튼
					Button {
						// Action
						toastManager.showToast(
							type: .info,
							title: "새로운 업데이트가 있습니다"
						)
					} label: {
						ToastDemoButton(
							title: "Info Toast",
							icon: "info.circle.fill",
							color: .blue
						)
					}
				} //:VSTACK
				.padding()
				
				Spacer()
				
			} //:VSTACK
			.navigationTitle("Toast System")
		} //:NAVSTACK
	}
	
	/// 화면 상단에 토스트들을 표시하는 오버레이
	private var toastOverlay: some View {
		VStack(spacing: 10) {
			ForEach(toastManager.activeToasts, id: \.self) { toast in
				ToastView(
					toast: toast,
					onDismiss: {
						// 클로저로 각 토스트의 닫기 액션 전달
						toastManager.dismissToast(toast)
					}
				)
				// 핵심! 각 토스트 타입별로 다른 Transition 효과 적용
				.transition(toast.type.transition)
				
			}
			
			Spacer()
			
			// MARK: - 현재 상태 표시 및 전체 삭제 버튼
			VStack(spacing: 10) {
				if !toastManager.activeToasts.isEmpty {
					Text("현재 \(toastManager.activeToasts.count)개의 토스트가 표시 중")
						.font(.caption)
						.foregroundStyle(.secondary)
					
					// 모든 토스트 닫기 버튼
					Button {
						// Action
						toastManager.dismissAllToast()
					} label: {
						Text("모든 토스트 닫기")
					}
					.buttonStyle(.bordered)
					.tint(Color.red)
					
				}
				
			} //:VSTACK
			
		} //:VSTACK
		.padding(.top, 50)
		.padding(.horizontal, 15)
	}
}

// MARK: - 개별 토스트 뷰 컴포넌트
/// 개별 토스트 알림을 표시하는 재사용 가능한 컴포넌트
struct ToastView: View {
	// properties
	/// 표시할 토스트 데이터
	let toast: ToastModel
	/// 닫기 버튼이 눌렸을 때 실행할 클로저
	let onDismiss: () -> Void
	
	var body: some View {
		HStack(spacing: 10) {
			// 아이콘 영역
			Image(systemName: toast.type.icon)
				.font(.title2)
				.foregroundStyle(.white)
				.frame(width: 25, height: 25)
			// 텍스트 컨텐츠 영역
			
			// 텍스트 컨텐츠 영역
			VStack(alignment: .leading, spacing: 5) {
				// 토스트 제목
				Text(toast.title)
					.font(.headline)
					.foregroundStyle(.white)
					.fontWeight(.semibold)
					.lineLimit(2) // 최대 2줄로 제한
				// 토스트 상세 메시지
				if let message = toast.message {
					Text(message)
						.font(.body)
						.foregroundStyle(.white)
						.lineLimit(3) // 최대 3줄로 제한
				}
			} //:VSTACK
			
			Spacer()
			
			// 닫기 버튼
			Button {
				// action
				onDismiss()
			} label: {
				Image(systemName: "xmark")
					.font(.body)
					.foregroundStyle(.white)
					.frame(width: 20, height: 20)
			}
			.frame(width: 50, height: 50) // 사용자에게 충분한 터치 영역 보장
			
		} //:HSTACK
		.padding()
		.background(
			// 토스트 배경 스타일링
			RoundedRectangle(cornerRadius: 15)
				.fill(toast.type.color)
				.shadow(
					color: toast.type.color.opacity(0.3),
					radius: 10,
					x: 0,
					y: 4
				)
		)
	}
}

/// 토스트 테스트 용 버튼 재사용이 가능한 컴포넌트
struct ToastDemoButton: View {
	// properties
	let title: String // 버튼 주요 텍스트
	let icon: String // 아이콘 이름
	let color: Color // 토스트 타입별 테마 색상
	
	var body: some View {
		HStack(spacing: 15) {
			// 아이콘 영역
			Image(systemName: icon)
				.font(.title3)
				.foregroundStyle(color)
				.frame(width: 25, height: 25)
			// 텍스트 영역
			Text(title)
				.font(.body)
				.fontWeight(.medium)
				.foregroundStyle(.black)
			
			Spacer()
			
			Image(systemName: "chevron.right")
				.font(.caption)
				.foregroundStyle(.secondary)
		} //:HSTACK
		.padding()
		.background(
			RoundedRectangle(cornerRadius: 15)
				.fill(color.opacity(0.1))
				.stroke(color.opacity(0.3), lineWidth: 1)
		)
	}
}

// MARK: - 프리뷰
#Preview {
    NotificationToastSystem()
}

#Preview("싱글 토스트") {
	VStack(spacing: 20) {
		ToastView(
			toast: ToastModel(
				type: .success,
				title: "저장 완료",
				message: "문서가 성공적으로 저장되었습니다",
				duration: 3.0
			),
			onDismiss: {}
		)
		
		// 에러 토스트 예시
		ToastView(
			toast: ToastModel(
				type: .error,
				title: "네트워크 오류",
				duration: 5.0
			),
			onDismiss: {}
		)
		
		Spacer()
		
	} //:VSTACK
	.padding()
}

#Preview("데모 버튼들") {
	VStack(spacing: 15) {
		
		ForEach(ToastModel.ToastType.allCases, id: \.self) { type in
			ToastDemoButton(
				title: type.description,
				icon: type.icon,
				color: type.color
			)
		} //:LOOP
	} //:VSTACK
	.padding()
}
