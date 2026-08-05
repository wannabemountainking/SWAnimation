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
    
    // MARK: - Computed Properties
    
    // MARK: - Method
}

// MARK: - 메인 온보딩 뷰

struct OnboardingTransition: View {
    /// 온보딩 메니져 인스턴스
    @State private var manager = OnboardingTransitionManager()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - 개별 단계 뷰 컴포넌트


// MARK: - 프리뷰
#Preview {
    OnboardingTransition()
}
