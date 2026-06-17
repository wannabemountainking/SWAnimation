//
//  TextAnimate.swift
//  SWAnimation
//
//  Created by YoonieMac on 6/16/26.
//

import SwiftUI
import Combine

/// TextAnimate 는 텍스트 크기 변화와 회전 에니메이션 효과 비교함
struct TextAnimate: View {
	
	// 버튼 트리거
	@State private var change: Bool = false
	// 텍스트 회전에 사용되는 현재 회전 각도
	@State private var rotationAngle: Double = 0
	
    var body: some View {
		VStack(spacing: 0) {
			TemplateView(
				title: "텍스트 에니메이션",
				descriptionText: "텍스트의 크기와 회전 효과를 비교합니다",
				content: {
					VStack(spacing: 40) {
						
						// MARK: - 텍스트 크기 변화 예제
						VStack(alignment: .leading, spacing: 10) {
							HStack(spacing: 10) {
								Text("텍스트 크기")
									.font(.title2)
									.foregroundStyle(.ppurple1)
								Text(": 크기 변화 효과")
									.font(.footnote)
									.foregroundStyle(.secondary)
							} //:HSTACK
							
							ZStack {
								Text("Hello")
									.font(.system(size: change ? 80 : 20))
									.foregroundStyle(.accent)
									.animation(.easeInOut(duration: 1), value: change)
							} //:ZSTACK
							.frame(width: 350, height: 100)
						} //:VSTACK
						
						// MARK: - 텍스트 회전 예제
						VStack(alignment: .leading, spacing: 10) {
							HStack(spacing: 10) {
								Text("텍스트 회전")
									.font(.title2)
									.foregroundStyle(.ppurple1)
								Text(": change가 true 이면 회전, false 이면 원위치")
									.font(.footnote)
									.foregroundStyle(.secondary)
							} //:HSTACK
							
							ZStack {
								Text("Rotate Me!")
									.font(.system(size: 40))
									.foregroundStyle(.accent)
									.rotationEffect(Angle.degrees(rotationAngle))
							}
							.frame(width: 300, height: 100)
							.onReceive(
								// Timer를 사용하여 0.01초 마다 이벤트 발생
								Timer.publish(
									every: 0.01,  // 0.01초 마다 이벤트 발생
									on: .main,    // UI 업데이트이므로 메인 쓰레드에서 실횅
									in: .common   // 제스처나 스크롤 중에 타이머를 정상적으로 동작할 수 있도록 common 사용
								)
								.autoconnect()   // Timer가 자동으로 시작하게 만듦
								,
								perform: { _ in
									if change {
										// rotationAngle을 4씩 증가시킴
										// 계속 늘어나면 360, 720,.... 무한히 커지기 때문에
										// 이걸 방지하려면 truncatingReminder 소수점 포함한 나머지를 반환
										// 얘: 372.truncatingReminder(dividingBy: 360) -> 12도
										rotationAngle = (rotationAngle + 4)
											.truncatingRemainder(dividingBy: 360)
									}
								}
							)
                            // change값이 변경될 때 어떤 각도에 있던지 간에 newValue == false인 경우, 즉 change가 true -> false로 바뀔 때 (버튼을 눌러 정지시킬 때 false가 됨) ratationAngle = 0 처리
                            .onChange(of: change) { _, newValue in
                                if !newValue {
                                    withAnimation(.easeInOut(duration: 1)) {
                                        rotationAngle = 0
                                    }
                                }
                            }
						} //:VSTACK
						
						Circle()
							.trim(from: 0, to: change ? 1 : 0)
							.stroke(Color.green, style: StrokeStyle(lineWidth: 5, lineCap: .round))
							.frame(width: 200, height: 200)
							.animation(.easeInOut(duration: 1), value: change)
					} //:VSTACK
				}//: contents
			) //: TemplateView
			
			PurpleButton(title: change ? "다시 원상태로" : "에니메이션 실행") {
				change.toggle()
			}
		} //:VSTACK
    }
}

#Preview {
    TextAnimate()
}
