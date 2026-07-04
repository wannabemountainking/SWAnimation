//
//  LandingAnimation.swift
//  SWAnimation
//
//  Created by YoonieMac on 7/4/26.
//

import SwiftUI

// MARK: - 1. 데이터 모델 정의
/// 기능 카드에 표시될 정보를 담는 데이터 모델
struct FeatureInfo: Identifiable {
	let id = UUID()          // ID
	let icon: String         // SF symbol 아이콘 이름
	let title: String        // 카드 제목
	let description: String  // 카드 설명
}

// MARK: - MainView
struct LandingAnimation1: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    LandingAnimation1()
}
