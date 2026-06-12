//
//  TemplateView.swift
//  SWAnimation
//
//  Created by yoonie on 6/13/26.
//

import SwiftUI


/// TemplateView는 강의 섹션 제목, 부제, 설명, 콘텐츠 및 추가 정보를 표시하는 템플릿
struct TemplateView<Content: View>: View {
    // MARK: - Properties
    let title: String            // 강의 제목 (필수)
    let descriptionText: String  // 섹션 설명 텍스트 (필수)
    let content: Content         // 사용자 정의 콘텐츠 영역 (필수)
    let notes: String?           // 추가 정보나 주의 사항 (옵셔널)
    
    init(
        title: String,
        descriptionText: String,
        @ViewBuilder content: () -> Content,
        notes: String?
    ) {
        self.title = title
        self.descriptionText = descriptionText
        self.content = content()
        self.notes = notes
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    TemplateView(
        title: "Animation 강의 Template",
        descriptionText: "간단한 설명",
        content: {
            VStack(spacing: 10) {
                Text("강의 내용 쭉")
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
            } //:VSTACK
        },
        notes: "주의사항: 팁: 옵셔널"
    )
}
