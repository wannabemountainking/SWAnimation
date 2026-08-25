//
//  LoadingView.swift
//  SWAnimation
//
//  Created by YoonieMac on 8/25/26.
//

import SwiftUI

/// 초기 로딩 시 표시되는 스켈레톤 뷰
struct LoadingView: View {
    var body: some View {
		ScrollView {
			LazyVStack(spacing: 30) {
				// 5개 카드 로딩 뷰
				ForEach(0..<5, id: \.self) { _ in
					HStack(spacing: 15) {
						// 아마타 스켈레톤
						SkeletonView(Circle())
							.frame(width: 80, height: 80)
						// 텍스트 정보들
						VStack(spacing: 10) {
							ForEach(0..<3, id: \.self) { _ in
								SkeletonView(RoundedRectangle(cornerRadius: 5))
									.frame(width: 250)
							}
							Spacer()
						} //:VSTACK
					} //:HSTACK
					.padding()
					.background(
						RoundedRectangle(cornerRadius: 15)
							.fill(Color.black.opacity(0.3))
					)
				}
			} //:VSTACK
		}
    }
}

#Preview {
    LoadingView()
}
