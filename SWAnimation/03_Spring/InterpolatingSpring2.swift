//
//  InterpolatingSpring2.swift
//  SWAnimation
//
//  Created by YoonieMac on 7/21/26.
//

import SwiftUI

// Mass (질량) : 에니메이션 대상의 무게감을 조절
// initialVelocity (초기 속도) : 에니메이션 시작 시의 속도

/// 데모 타입을 정하는 열거형
enum DemoType: String, CaseIterable {
	case mass = "Mass 비교"
	case velocity = "Initial Velocity 비교"
}

struct InterpolatingSpring2: View {
	
	@State private var currentDemo: DemoType = .mass
	
    var body: some View {
		TemplateView(
			title: "Interpolating 고급 매개 변수",
			descriptionText: "Mass (질량), initialVelocity (초기 속도) 가 에니메이션에 미치는 영향을 비교하세요",
			content: {
				VStack(spacing: 30) {
					
					// MARK: - 데모 타입 선택 세그먼트
					VStack(spacing: 15) {
						Text("매개변수 선택")
							.font(.headline)
							.foregroundStyle(.accent)
						Picker("Demo Type", selection: $currentDemo) {
							ForEach(DemoType.allCases, id: \.self) { demo in
								Text(demo.rawValue)
									.tag(demo)
							} //:LOOP
						}//: PICKER
						.pickerStyle(.segmented)
					} //:VSTACK
					
					// MARK: - 선택된 데모 표시
					Group {
						switch currentDemo {
						case .mass:
							MassComparisonView()
						case .velocity:
							VelocityComparisonView()
						}
					} //: Group
				} //:VSTACK
			}//: CONTENT
		) // : TemplateView
    }
}

// MARK: - Mass 비교 뷰
/// 서로 다른 mass 값을 가진 공들이 떨어지는 모습을 비교하는 뷰
struct MassComparisonView: View {
	@State private var animate: Bool = false
	
	/// 다양한 질량 값으로 물리적 특성 비교
	private let masses: [(value: Double, label: String, color: Color)] = [
		(value: 0.5, label: "가벼움", color: .blue),
		(value: 1.0, label: "보통", color: .ppurple1),
		(value: 1.5, label: "무거움", color: .ppurple2),
		(value: 2.0, label: "매우 무거움", color: .accent)
	]
	
	var body: some View {
		VStack(spacing: 20) {
			// 설명 텍스트
			VStack(spacing: 10) {
				Text("질량 별 낙하 비교")
					.font(.headline)
					.foregroundStyle(.accent)
				Text("질량이 클수록 무겁게 움직이며 반동이 줄어듭니다")
					.font(.caption)
					.foregroundStyle(.gray)
					.multilineTextAlignment(.center)
				
				// 공 떨어뜨리기 시뮬래이션
				HStack(spacing: 25) {
					ForEach(masses, id: \.value) { mass in
						BallDropColumn(
							ballColor: mass.color,
							label: mass.label,
							value: "\(mass.value)",
							animate: animate,
							animation: .interpolatingSpring(
								mass: mass.value,
								stiffness: 100,
								damping: 8,
								initialVelocity: 0
							)
						)
					}
				} //:HSTACK
				
				// 컨트롤 버튼
				PurpleButton(
					title: animate ? "리셋" : "공 떨어뜨리기",
					action: { animate.toggle() }
				)
				
			} //:VSTACK
		} //:VSTACK
	}
}

// MARK: - Initial Velocity 비교 뷰
/// 서로 다른 초기 속도를 가진 공들의 움직임을 비교하는 뷰
struct VelocityComparisonView: View {
	@State private var animate: Bool = false
	
	/// 다양한 질량 값으로 물리적 특성 비교
	private let velocities: [(value: Double, label: String, color: Color)] = [
		(value: 0.0, label: "정적 시작", color: .blue),
		(value: 10.0, label: "부드러운 시작", color: .ppurple1),
		(value: 30.0, label: "빠른 시작", color: .ppurple2),
		(value: 60.0, label: "매우 빠른 시작", color: .accent)
	]
	
	var body: some View {
		VStack(spacing: 20) {
			// 설명 텍스트
			VStack(spacing: 10) {
				Text("초기 속도별 반응 비교")
					.font(.headline)
					.foregroundStyle(.accent)
				Text("초기 속도가 클수록 빠르게 출발하여 더 강한 튕김을 보입니다")
					.font(.caption)
					.foregroundStyle(.gray)
					.multilineTextAlignment(.center)
				
				// 공 떨어뜨리기 시뮬래이션
				HStack(spacing: 25) {
					ForEach(velocities, id: \.value) { velocity in
						BallDropColumn(
							ballColor: velocity.color,
							label: velocity.label,
							value: "\(velocity.value)",
							animate: animate,
							animation: .interpolatingSpring(
								mass: 1.0,
								stiffness: 100,
								damping: 8,
								initialVelocity: velocity.value
							)
						)
					}
				} //:HSTACK
				
				// 컨트롤 버튼
				PurpleButton(
					title: animate ? "리셋" : "공 떨어뜨리기",
					action: { animate.toggle() }
				)
				
			} //:VSTACK
		} //:VSTACK
	}
}

// MARK: - 볼 드롭 컬럼 컴포넌트
/// 개별 공의 에니메이션을 보여주는 재사용 가능한 컴포넌트
struct BallDropColumn: View {
	let ballColor: Color
	let label: String
	let value: String
	let animate: Bool
	let animation: Animation
	
	// 에니메이션 drop 거리
	private let dropDistance: CGFloat = 200
	
	var body: some View {
		VStack(spacing: 15) {
			// 공이 떨어지는 영역
			ZStack {
				// 낙하 경로 표시
				RoundedRectangle(cornerRadius: 5)
					.fill(.gray.opacity(0.1))
					.frame(width: 6, height: dropDistance)
				VStack {
					// 떨어지는 공
					Circle()
						.fill(ballColor.gradient)
						.frame(width: 35, height: 35)
						.offset(y: animate ? dropDistance - 35 : 0)
						.animation(animation, value: animate)
					Spacer()
				} //:VSTACK
			} //:ZSTACK
			.frame(height: dropDistance)
			
			// 레이블과 값 표시
			VStack(spacing: 5) {
				Text(label)
					.font(.caption)
					.fontWeight(.semibold)
					.foregroundStyle(.accent)
				
				Text(value)
					.font(.caption2)
					.foregroundStyle(.gray)
			} //:VSTACK
		} //:VSTACK
	}
}

#Preview("초기뷰") {
    InterpolatingSpring2()
}

#Preview("볼 드롭") {
	BallDropColumn(
		ballColor: .accent,
		label: "가벼움",
		value: "1.0",
		animate: false,
		animation: .interpolatingSpring(
			mass: 1.0,
			stiffness: 100,
			damping: 8,
			initialVelocity: 0
		)
	)
}

#Preview("Velocity뷰") {
	VelocityComparisonView()
}
