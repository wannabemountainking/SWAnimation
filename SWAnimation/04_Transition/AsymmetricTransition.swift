//
//  AsymmetricTransition.swift
//  SWAnimation
//
//  Created by YoonieMac on 8/3/26.
//

import SwiftUI

// MARK: - 1. 기본 Asymmetric Transtion 뷰
/// 가장 기본적인 Asymmetric Transition 연습
struct AsymmetricTransition: View {
	
	@State private var showCard: Bool = false // 카드 표시 트리거
	
    var body: some View {
		TemplateView(
			title: "Asymmetric 기본",
			descriptionText: "나타날 때와 사라질 때 서로 다른 전환 효과를 적용할 수 있습니다",
			content: {
				VStack(spacing: 30) {
					// 실행 버튼
					PurpleButton(
						title: showCard ? "카드 숨기기" : "카드 보기",
						action: {
							withAnimation(.easeInOut(duration: 1)) {
								showCard.toggle()
							}
						}
					)
					
					Spacer()
					
					// 메인 Contents: 카드 공간과 카드를 겹쳐서 놓을 예정
					ZStack {
						// Background Color: 카드가 나타날 영역을 시각적으로 테두리 표시
						RoundedRectangle(cornerRadius: 20)
							.stroke(
								Color.ppurple1,
								style: StrokeStyle(lineWidth: 2, dash: [4, 8])
							)
							.frame(height: 250)
						// Content
						if showCard {
							VStack(spacing: 15) {
								// 아이콘
								Image(systemName: "star.fill")
									.font(.system(size: 40))
									.foregroundStyle(.accent)
								// 메인 텍스트
								Text("안녕하세요 !")
									.font(.title2)
									.foregroundStyle(.accent)
								// 설명 텍스트
								Text("나타날 때 Slide 효과\n사라질 때 Scale 효과")
									.font(.caption)
									.foregroundStyle(.secondary)
									.multilineTextAlignment(.center)
							} //:VSTACK
							.padding(30)
							.background(
								RoundedRectangle(cornerRadius: 20)
									.fill(Color.ppink.opacity(0.8))
									.frame(width: 300)
							)
							.shadow(radius: 10)
							// 중요!! Transition 효과 적용
							.transition(
								.asymmetric(
									insertion: .slide,  // 나타날 때: 기본 슬라이드
									removal: .scale     // 사라질 때: 스케일 축소
								)
							)
						}//:CONDITIONAL
					} //:ZSTACK
				} //:VSTACK
			},
			notes: "insertion: 뷰가 나타날 때의 전환 효과\nremoval: 뷰가 사라질 때의 전환 효과"
		)
    }
}

// MARK: - 2. Asymmetric 실전 연습 (카운트 알림창)

struct AsymmetricTransitionCount: View {
	/// 알림 표시 / 숨김 상태 관리
	@State private var showNotification: Bool = false
	/// 카운트다운 숫자 (5초부터 시작)
	@State private var countDown: Int = 5
	/// 타이머 객체 참조 (메모리 관리를 위해 옵셔널 선언)
	@State private var countDownTimer: Timer?

	var body: some View {
		TemplateView(
			title: "Combined Asymmetric",
			descriptionText: "Asymmetric과 Combined를 조합하여 여러 Transition 효과를 섞을 수 있습니다",
			content: {
				// 컨텐트 들을 겹칠 예정
				ZStack {
					// 메인 Contents
					VStack(spacing: 40) {
						// 알림 실행 버튼
						PurpleButton(
							title: "알림 표시",
							action: {
								withAnimation {
									showNotification = true // 알림창 열기
									countDown = 5           // 카운트 다운 초기화
								}// withAnimation
								// 카운트 다운 시작 로직
								startCountdonw()
							}// action
						)
						
						Spacer()
						
						// 설명 텍스트 영역
						VStack(spacing: 10) {
							Text("알림 전환 효과")
								.fontWeight(.semibold)
							Text("- 나타날 때: 좌 상단에서 스케일 + 오프셋")
								.font(.caption)
							Text("- 사라질 때: 투명도 + 스케일")
								.font(.caption)
							
						} //:VSTACK
						.foregroundStyle(.secondary)
					} //:VSTACK
					.padding()
					
					// MARK: - 알림 카드 (중앙에 위치)
					if showNotification {
						VStack(alignment: .leading, spacing: 15) {
							// 알림 헤더
							HStack(spacing: 10) {
								Image(systemName: "bell.fill")
									.foregroundStyle(.accent)
								Text("새 알림")
									.fontWeight(.semibold)
								Spacer()
							} //:HSTACK
							// 알림 본문
							Text("메시지가 도착했습니댜")
								.font(.body)
							// 동적 카운트 다운 텍스트
							Text("\(countDown)초 후 자동으로 사라집니다")
								.font(.caption)
								.foregroundStyle(.secondary)
						} //:VSTACK
						.padding(15)
						.background(
							RoundedRectangle(cornerRadius: 15)
								.fill(.ppink)
								.shadow(radius: 10)
						)
						.frame(maxWidth: 280)
						
						// 알림 위치 설정
						.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
						.zIndex(999)  // 다른 요소보다 알림 메시지 최상단
						
						// MARK: - 고급 Asymmetric Transition 효과
						.transition(
							.asymmetric(
								// 등장할 때 3가지 조합
								insertion: .offset(x: 300, y: -50)
									.combined(with: .scale(scale: 0.3, anchor: .topLeading))
									.combined(with: .opacity)
//								insertion: .scale(scale: 0.3, anchor: .topLeading) // 1. 좌상단 스케일
//									.combined(with: .offset(x: 300, y: -50)) // 2. 오른쪽 위에서 시작
//									.combined(with: .opacity)  // 3. 투명도 증가
								,
								// 퇴장할 때 2가지 조합
								removal: .scale(scale: 0.8) // 1. 0.8 배 축소
									.combined(with: .opacity) // 2. 투명도 감소
							)
						)
					}
				} //:ZSTACK
			},
			notes: "anchor 파라미터를 활용하면 특정 지점을 기준으로 스케일 효과를 적용할 수 있습니다\nTimer를 사용해 실시간 카운트 다운도 구현할 수 있습니다"
		)
	}
	
	// MARK: - 카운트 다운 함수
	private func startCountdonw() {
		// 1. 이전 타이머가 실행 중이라면 중단 (메모리 누수 방지)
		countDownTimer?.invalidate()
		// 2. 새 타이머 생성 및 실행
		// withTimeInterval: 1.0  1초 마다 실행
		// repeats: true 반복 실행
		countDownTimer = Timer.scheduledTimer(
			withTimeInterval: 1.0,
			repeats: true,
			block: { timer in
				countDown -= 1 // 카운트 다운 감소
				
				// 카운트 다운 완료 처리
				if countDown <= 0 {
					timer.invalidate()  // 타이머 중단
					countDownTimer = nil // Timer 참조 해제 (메모리 중단)
					
					withAnimation {
						showNotification = false
					}
				}
			}
		)
	}
}

#Preview("기본 비대칭 Transition") {
    AsymmetricTransition()
}

#Preview("비대칭 카운트다운 Transition") {
	AsymmetricTransitionCount()
}
