//
//  LocationAnimate.swift
//  SWAnimation
//
//  Created by YoonieMac on 6/15/26.
//

import SwiftUI


/// offset, 정렬, GeometryReader 방식을 사용해서 위치 변경 애니메이션 비교 예제
struct LocationAnimate: View {
	
	@State private var change: Bool = false
	
    var body: some View {
		VStack(spacing: 0) {
			TemplateView(
				title: "위치 변경 애니메이션",
				descriptionText: "offset, Spacer(), GeometryReader 방식을 간략하게 비교해 봅니다",
				content: {
					VStack(spacing: 30) {
						// MARK: - offset 방식 예제
						VStack(alignment: .leading, spacing: 10) {
							HStack {
								Text("Offset")
									.font(.title2)
									.foregroundStyle(Color.secondary)
								Text(": 직접 x 축 값으로 위치 변경")
									.font(.footnote)
									.foregroundStyle(Color.secondary)
							} //:HSTACK
							RoundedRectangle(cornerRadius: 10)
								.frame(width: 100, height: 100)
								.foregroundStyle(.accent)
								.offset(x: change ? 0 : 250, y: 0) // 상태에 따라 x축으로 250 이동
								.animation(.default, value: change)
							
							// MARK: - 정렬 방식 예제
							// HStack 내부에 Spacer를 사용해서 좌우 이동 애니메이션 구현
							VStack(alignment: .leading, spacing: 10) {
								HStack {
									Text("Alignment")
										.font(.title2)
										.foregroundStyle(Color.ppurple1)
									Text(": 컨테이너 내 정렬 변경")
										.font(.footnote)
										.foregroundStyle(Color.secondary)
								} //:HSTACK
								HStack {
									// change가 true일 경우 Spacer를 먼저 배치해 오른쪽 정렬
									if change { Spacer() }
									
									RoundedRectangle(cornerRadius: 10)
										.frame(width: 100, height: 100)
										.foregroundStyle(.accent)
										.animation(.default, value: change)
									
									// change가 false이면 RoundedRectangle 뒤에 Spacer 배치
									if !change { Spacer() }
								} //:HSTACK
							} //:VSTACK
							
							// MARK: - GeometryReader 방식 예제
							/// GeometryReader 내부의 좌표 공간을 사용해 RoundedRectangle의 중심위치를 동적으로 계산해서 배치
							VStack(alignment: .leading, spacing: 10) {
								HStack {
									Text("GeometryReader")
										.font(.title2)
										.foregroundStyle(Color.ppurple1)
									Text(": 좌표 공간 내 위치 변경")
										.font(.footnote)
										.foregroundStyle(Color.secondary)
								} //:HSTACK
								
								GeometryReader { gp in
									// 상태에 따라 RoundedRectangle의 중심을 GeometryReader의 크기에 따라 계산
									RoundedRectangle(cornerRadius: 10)
										.frame(width: 100, height: 100)
										.foregroundStyle(.accent)
										.position(
											change
											? CGPoint(x: 50, y: 50)
											: CGPoint(x: gp.size.width - 50, y: gp.size.height - 50)
										)
										.animation(.default, value: change)
								}
								.frame(height: 150)
							} //:VSTACK
						} //:VSTACK
					} //:VSTACK
				} //: Contents
			) //: TemplateView
			
			PurpleButton(
				title: change ? "다시 원위치로" : "에니메이션 실행",
				action: { change.toggle() }
			)
			.padding()
		} //:VSTACK
    }
}

#Preview {
    LocationAnimate()
}
