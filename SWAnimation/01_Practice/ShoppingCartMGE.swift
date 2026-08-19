//
//  ShoppingCartMGE.swift
//  SWAnimation
//
//  Created by yoonie on 8/19/26.
//

import SwiftUI

// MARK: - 상품 데이터 모델
/// 상품 정보를 담는 데이터 모델
struct Product: Identifiable {
    let id = UUID() // 고유 ID 식별자
    let name: String // 상품명
    let price: Int  // 가격 (원 단위)
    let icon: String  // SF Symbol 아이콘 이름
}
/// 장바구니 항목 데이터 모델
struct CartItem: Identifiable {
    let id = UUID() // 장바구니의 개별 제품 ID 식별자
    let product: Product // 장바구니의 개별 제품(상품 정보)
    var quantity: Int  // 수량 (변경 가능)
    
    // 장바구니 개별 제품의  가격 소계 자동 계산
    var subtotalPrice: Int {
        product.price * quantity
    }
}

// MARK: - 메인 쇼핑 화면
/// 상품 목록과 장바구니 화면을 관리하는 메인 컨테이너
struct ShoppingCartMGE: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ShoppingCartMGE()
}
