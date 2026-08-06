//
//  OnboardingTransition.swift
//  SWAnimation
//
//  Created by yoonie on 8/5/26.
//

import SwiftUI
import Observation

// MARK: - 온보딩 데이터 모델

struct OnboardingTransitionModel: Identifiable {
    // 1. properties
    let id = UUID() // ID 값
    let stepNumber: Int // 단계 번호
    let title: String // 단계 별 주요 제목
    let subtitle: String // 단계 별 부 제목 또는 설명
    let description: String // 상세 설명 텍스트
    let imageName: String // SF Symbol 이미지 이름
    let accentColor: Color // 단계 별 강조 색상
    let buttonText: String // 하단 버튼 텍스트
    
    // 2. computed properties
    /// 현재 단계가 마지막 단계인지 확인하는 계산속성
    var isLastStep: Bool {
        stepNumber == 4
    }
    /// 현재 단계가 첫 번째 단계인지 확인하는 계산 속성
    var isFirstStep: Bool {
        stepNumber == 1
    }
}

// MARK: - 온보딩 메니저
@Observable
class OnboardingTransitionManager {
    // MARK: - Stored properties(기본값)
    
    /// 현재 온보딩 단계 1부터 시작
    var currentStep: Int = 1
    
    /// 온보딩이 완료되었는지 여부
    var isCompleted: Bool = false
    
    /// 사용자가 앞으로 이동 중인지 뒤로 이동 중인지를 추적
    var isMovingForward: Bool = false
    
    // MARK: - 온보딩 단계 데이터
	/// 모든 온보딩 단계의 데이터를 담은 배열 (Mock Data)
	let onboardingSteps: [OnboardingTransitionModel] = [
		OnboardingTransitionModel(
			stepNumber: 1,
			title: "환영합니다!",
			subtitle: "새로운 경험의 시작",
			description: "이 앱과 함께 더 나은 일상을 만들어보세요.\n간단한 설정으로 시작할 수 있습니다.",
			imageName: "hand.wave.fill",
			accentColor: Color.accent,
			buttonText: "시작하기"
		),
		OnboardingTransitionModel(
			stepNumber: 2,
			title: "강력한 기능들",
			subtitle: "모든 것이 한 곳에",
			description: "직관적인 인터페이스와 스마트한 기능들로\n작업 효율성을 극대화하세요.",
			imageName: "star.circle.fill",
			accentColor: Color.ppurple1,
			buttonText: "계속"
		),
		OnboardingTransitionModel(
			stepNumber: 3,
			title: "알림 설정",
			subtitle: "놓치지 마세요",
			description: "중요한 업데이트와 알림을 받아보시려면\n알림 권한을 허용해주세요.",
			imageName: "bell.circle.fill",
			accentColor: Color.ppurple2,
			buttonText: "권한 허용"
		),
		OnboardingTransitionModel(
			stepNumber: 4,
			title: "모든 준비 완료!",
			subtitle: "지금 바로 시작하세요",
			description: "설정이 완료되었습니다.\n이제 앱의 모든 기능을 사용할 수 있습니다!",
			imageName: "checkmark.circle.fill",
			accentColor: Color.ppink,
			buttonText: "앱 시작하기"
		)
	]
    
    // MARK: - Computed Properties
	/// 총단계 수 변환
	var totalSteps: Int {
		onboardingSteps.count
	}
	
	/// 현재 단계에 해당하는 onboardingstep의 변환
	var currentStepData: OnboardingTransitionModel {
		guard currentStep > 0 && currentStep <= onboardingSteps.count else { return onboardingSteps[0] }
		return onboardingSteps[currentStep - 1] // 배열은 0부터 시작하므로 -1
	}
	
	/// 현재 진행률 계산
	var progress: Double {
		return Double(currentStep) / Double(onboardingSteps.count)
	}
	
    // MARK: - Method
	/// 온보딩 완료하는 함수
	func completeOnboarding() {
		isCompleted = true
	}
	/// 다음 단계로 이동하는 함수
	func goToNextStep() {
		// 1. 이동방향 설정
		isMovingForward = true
		
		// 만약 현재 페이지 번호가 전체 페이지의 마지막 번호보다 작으면
		if currentStep < totalSteps {
			// 현재페이지 += 1 증가
			currentStep += 1 // 다음 페이지로 1씩 증가
		} else { // 현재 페이지 번호가 마지막 페이지 번호와 같거나 크다면 (같겠제)
			// 다음 화면으로 이동
			completeOnboarding()
		}
	}
	/// 이전 단계로 이동하는 함수
	func goToPreviousStep()
}

// MARK: - 메인 온보딩 뷰

struct OnboardingTransition: View {
    /// 온보딩 메니져 인스턴스
    @State private var manager = OnboardingTransitionManager()
    
    var body: some View {
		ZStack {
			// Background Color
			Color.black
				.ignoresSafeArea()
			// Content
			// MARK: - 조건부 랜더링
			if manager.isCompleted {
				// 완료 화면
				completionView
				
			} else {
				VStack(spacing: 0) {
					// 온보딩 실제 뷰
					// 1. 진행률 표시 및 네비게이션 (헤더)
					progressHeader
					
					Spacer()
					// 2. 단계 별 콘텐츠 (바디)
					stepContent
					
					Spacer()
					// 3. 하단 네비게이션 버튼
					navigationButtons
					
				} //:VSTAC
			}//:CONDITIONAL
		} //:ZSTACK
    }
	
	// MARK: - 헤더 영역
	/// 상단의 진행률 바와 단계 표시
	private var progressHeader: some View {
		VStack(spacing: 20) {
			// 단계 표시와 건너뛰기 버튼
			HStack(spacing: 10) {
				// 현재단계 / 총 단계
				Text("\(manager.currentStep) / \(manager.totalSteps)")
					.font(.caption)
					.foregroundStyle(.gray)
				Spacer()
				// 건너 뛰기 버튼
				if !manager.currentStepData.isLastStep {
					Button {
						// action
						manager.completeOnboarding()
					} label: {
						Text("건너뛰기")
							.font(.caption)
							.foregroundStyle(.gray)
					}
				}//:CONDITIONAL
			} //:HSTACK
			// 진행바 구현
			GeometryReader { geo in
				ZStack(alignment: .leading) {
					// Background Color: 전체 진행률 영역 표시
					RoundedRectangle(cornerRadius: 5)
						.fill(Color.gray.opacity(0.3))
						.frame(height: 10)
					// Content: 현재 단계의 강조 색상 사용
					RoundedRectangle(cornerRadius: 5)
						.fill(manager.currentStepData.accentColor)
						.frame(
							width: geo.size.width * manager.progress,
							height: 10
						)
						.animation(.easeInOut(duration: 0.5), value: manager.progress)
				} //:ZSTACK
			} //:GEOMETRY
			.frame(height: 10)
			
		} //:VSTACK
		.padding(.horizontal, 25)
		.padding(.top, 20)
	}
	
	// MARK: - 바디 영역
	/// 현재 단계의 콘텐츠를 표시하는 영역
	private var stepContent: some View {
		Group {
			// 조건뷰 페이지 랜더링 : SwiftUI가 View ID를 추적해서 animation 적용
//			if manager.currentStep == 1 {
//				OnboardingStepView(step: manager.onboardingSteps[0])
//			} else if manager.currentStep == 2 {
//				OnboardingStepView(step: manager.onboardingSteps[1])
//			} else if manager.currentStep == 3 {
//				OnboardingStepView(step: manager.onboardingSteps[2])
//			} else if manager.currentStep == 4 {
//				OnboardingStepView(step: manager.onboardingSteps[3])
//			}
			OnboardingStepView(step: manager.onboardingSteps[manager.currentStep - 1])
		}
	}
	
	// MARK: - 하단 버튼 영역
	/// 메인 액션 버튼, 이전/다음 네비게이션 시스템
	private var navigationButtons: some View {
		VStack(spacing: 20) {
			// 메인 Action 버튼
			Button {
				// action
				withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
					manager.goToNextStep()
				}
			} label: {
				Text(manager.currentStepData.buttonText)
					.font(.headline)
					.fontWeight(.semibold)
					.foregroundStyle(.white)
					.frame(maxWidth: .infinity)
					.frame(height: 55)
					.background(
						RoundedRectangle(cornerRadius: 15)
							.fill(manager.currentStepData.accentColor)
					)
					.shadow(
						color: manager.currentStepData.accentColor,
						radius: 10,
						x: 0,
						y: 4
					)
			}
			// 보조 네비게이션과 인디케이터
			HStack(spacing: 10) {
				// 1. 이전 버튼
				if !manager.currentStepData.isFirstStep {
					Button {
						// action
						withAnimation(.spring) {
							manager.goToPreviousStep()
						}
					} label: {
						Text("이전")
							.foregroundStyle(.gray)
					}

				}
				// 2. 단계 인디케이터 점들
				
				// 3. 다음 버틑 (마지막 단계가 아닐 때만)
				
			} //:HSTACK
			
		} //:VSTACK
		.padding(.horizontal, 25)
		.padding(.bottom, 40)
	}
	
	// MARK: - 완료 화면
	/// 온보딩 완료 후 표시되는 성공 화면
	private var completionView: some View {
		Text("완료 화면")
	}
}

// MARK: - 개별 단계 뷰 컴포넌트
/// 각 온보딩 단계 뷰 컴포넌트
struct OnboardingStepView: View {
	// 표시할 단계 데이터
	let step: OnboardingTransitionModel
	
	var body: some View {
		VStack(spacing: 30) {
			ZStack {
				// Background Color
				Circle()
					.fill(step.accentColor.opacity(0.5))
					.frame(width: 120, height: 120)
				// Content - 아이콘
				Image(systemName: step.imageName)
					.font(.system(size: 50))
					.foregroundStyle(step.accentColor)
				
			} //:ZSTACK
			
			// 텍스트 콘텐츠 영역
			VStack(spacing: 15) {
				// 메인 타이틀
				Text(step.title)
					.font(.title)
					.fontWeight(.bold)
					.foregroundStyle(.white)
				// 부 제목
				Text(step.subtitle)
					.font(.title3)
					.fontWeight(.medium)
					.foregroundStyle(.gray)
				// 상세 설명
				Text(step.description)
					.font(.body)
					.foregroundStyle(.gray.opacity(0.5))
					.multilineTextAlignment(.center)
					.lineSpacing(4)
			} //:VSTACK
		} //:VSTACK
		.padding(.horizontal, 30)
	}
}

// MARK: - 프리뷰
#Preview {
    OnboardingTransition()
}

#Preview("Single Step") {
	ZStack {
		// Background Color
		Color.black
			.ignoresSafeArea()
		// Content
		OnboardingStepView(
			step: OnboardingTransitionModel(
				stepNumber: 1,
				title: "환영합니다!",
				subtitle: "새로운 경험의 시작",
				description: "이 앱과 더 나은\n간단한 설정 시작",
				imageName: "hand.wave.fill",
				accentColor: .accent,
				buttonText: "시작하기"
			)
		)
	} //:ZSTACK
}
