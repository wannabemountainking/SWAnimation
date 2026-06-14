//
//  Curves1.swift
//  SWAnimation
//
//  Created by YoonieMac on 6/14/26.
//

import SwiftUI


/// 기본 에니메이션 커브 (easeInOut, easeIn, easeOut, linear) 차이를 비교하는 코드
struct Curves1: View {
	
	@State private var move: Bool = false
	
    var body: some View {
		VStack(spacing: 0) {
			TemplateView(
				title: "에니메이션 커브 비교",
				descriptionText: "에니메이션 전후의 차이를 간략하게 확인합니다",
				content: {
					
					// MARK: - easeInOut 예제
					VStack(alignment: .leading, spacing: 10) {
						HStack {
							Text("easeInOut")
								.font(.title2)
								.foregroundStyle(Color.ppurple1)
							Text(": 천천히 시작해 가속 후 감속 (기본값)")
								.font(.footnote)
								.foregroundStyle(Color.secondary)
						} //:HSTACK
						
						Circle()
							.foregroundStyle(.accent)
							.frame(width: 50, height: 50)
							.offset(x: move ? 300 : 0)
							.animation(.easeInOut(duration: 1), value: move)
					} //:VSTACK
					
					// MARK: - easeIn 예제
					VStack(alignment: .leading, spacing: 10) {
						HStack {
							Text("easeIn")
								.font(.title2)
								.foregroundStyle(Color.ppurple1)
							Text(": 느리게 시작해 가속됨")
								.font(.footnote)
								.foregroundStyle(Color.secondary)
						} //:HSTACK
						
						Circle()
							.foregroundStyle(.accent)
							.frame(width: 50, height: 50)
							.offset(x: move ? 300 : 0)
							.animation(.easeIn(duration: 1), value: move)
					} //:VSTACK
					
					// MARK: - easeOut 예제
					VStack(alignment: .leading, spacing: 10) {
						HStack {
							Text("easeOut")
								.font(.title2)
								.foregroundStyle(Color.ppurple1)
							Text(": 빠르게 시작해서 감속")
								.font(.footnote)
								.foregroundStyle(Color.secondary)
						} //:HSTACK
						
						Circle()
							.foregroundStyle(.accent)
							.frame(width: 50, height: 50)
							.offset(x: move ? 300 : 0)
							.animation(.easeOut(duration: 1), value: move)
					} //:VSTACK
					
					// MARK: - Linear 예제
					VStack(alignment: .leading, spacing: 10) {
						HStack {
							Text("linear")
								.font(.title2)
								.foregroundStyle(Color.ppurple1)
							Text(": 일정한 속도로 이동")
								.font(.footnote)
								.foregroundStyle(Color.secondary)
						} //:HSTACK
						
						Circle()
							.foregroundStyle(.accent)
							.frame(width: 50, height: 50)
							.offset(x: move ? 300 : 0)
							.animation(.linear(duration: 1), value: move)
					} //:VSTACK
				},
				notes: "네 가지 에니메이션 커브는 모두 동일한 1초 동안 실행되지만 처음, 중간, 마지막 속도 차이로 다른 느낌의 에니메이션을 전달함"
			)
			
			PurpleButton(title: move ? "다시 원위치로" : "에니메이션 실행") {
				move.toggle()
			}
		}
    }
}

#Preview {
    Curves1()
}
