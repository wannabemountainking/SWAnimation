//
//  SkeletonView.swift
//  SWAnimation
//
//  Created by YoonieMac on 7/5/26.
//

import SwiftUI


/// 로딩 중 화면에서 사용하는 스켈레톤 에니메이션 -> 재사용 가능한 Generic 컴포넌트
struct SkeletonView<S: Shape>: View {
	
	let shape: S
	let color: Color
	
	@State private var animate: Bool = false
	
	init(_ shape: S, color: Color = .gray.opacity(0.3)) {
		self.shape = shape
		self.color = color
	}
	
    var body: some View {
		shape
			.fill(color)
			.overlay {
				// shimmer 효과 생성
				GeometryReader { geo in
					createShimmerEffect(size: geo.size)
				}
				.mask(shape) // 도형 경계 내에만 효과 적용
			}
			.onAppear {
				animate = true
			}
    }
	
	@ViewBuilder
	private func createShimmerEffect(size: CGSize) -> some View {
		Rectangle()
			.fill(Color.white.opacity(0.5))
			.frame(width: size.width * 0.6, height: size.height * 2)
			.rotationEffect(.degrees(15)) // 대각선 효과
			.offset(x: animate ? size.width : -size.width * 0.6)
			.blur(radius: 20)
			.animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false), value: animate)
	}
}


// MARK: - Extension
extension View {
	func skeleton(isLoading: Bool) -> some View {
		Group {
			if isLoading {
				SkeletonView(RoundedRectangle(cornerRadius: 10))
			} else {
				self
			}
		}
	}
}

#Preview {
	
	VStack(spacing: 20) {
		SkeletonView(Circle())
			.frame(width: 80, height: 80)
		
		SkeletonView(RoundedRectangle(cornerRadius: 10))
			.frame(height: 20)
		
		SkeletonView(Capsule())
			.frame(width: 200, height: 50)
		
		SkeletonView(RoundedRectangle(cornerRadius: 20), color: .ppink.opacity(0.3))
	} //:VSTACK
	.padding()
}
