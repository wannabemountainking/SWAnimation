//
//  FrameOpcityAnimate.swift
//  SWAnimation
//
//  Created by yoonie on 6/15/26.
//

import SwiftUI

struct FrameOpcityAnimate: View {
    
    @State private var change: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            TemplateView(
                title: "크기와 불투명도 스케일 에니메이션 강의",
                descriptionText: "프레임 크기와 불투명도, scaleEffect (앵커기준) 방식을 간략하게 비교합니다",
                content: {
                    VStack(alignment: .leading, spacing: 40) {
                        
                        // MARK: - Frame & Opacity 예제
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Frame & Opacity")
                                    .font(.title2)
                                    .foregroundStyle(.ppurple1)
                                Text(": 크기와 불투명도 동시에 변경")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            } //:HSTACK
                            
                            // 외부 컨테이너 크기를 고정해서 애니메이션 실행 시 다른 콘텐츠가 밀리지 않도록 보장
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: change ? 100 : 350, height: change ? 100 : 200)
                                    .foregroundStyle(.accent)
                                    .opacity(change ? 0.2 : 1)
                                    .animation(.easeInOut(duration: 1), value: change)
                            } //:ZSTACK
                            .frame(width: 350, height: 200, alignment: .leading)
                        }//: VStack(spacing: 20)
                        
                        // MARK: - ScaleEffect  예제
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("ScaleEffect")
                                    .font(.title2)
                                    .foregroundStyle(.ppurple1)
                                Text(": Anchor 크기 기준 변화")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            } //:HSTACK
                            
                            HStack(spacing: 20) {
                                // Top Leading 엥커 기준 예제
                                VStack(spacing: 10) {
                                    Text("Top Leading")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                    Circle()
                                        .frame(width: 100, height: 100)
                                        .foregroundStyle(.accent)
                                        .scaleEffect(change ? 1 : 0.5, anchor: .topLeading)
                                        .animation(.default, value: change)
                                } //:VSTACK
                                
                                // Trailing 엥커 기준 예제
                                VStack(spacing: 10) {
                                    Text("Top Leading")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                    Circle()
                                        .frame(width: 100, height: 100)
                                        .foregroundStyle(.accent)
                                        .scaleEffect(change ? 0.5 : 1, anchor: .trailing)
                                        .animation(.default, value: change)
                                } //:VSTACK
                            } //:HSTACK
                        }//: VStack(spacing: 20)
                    } //:VSTACK
                }//: content
            )
            
            PurpleButton(title: change ? "다시 원위치로" : "에니메이션 실행") {
                change.toggle()
            }
        } //:VSTACK
    }
}

#Preview {
    FrameOpcityAnimate()
}
