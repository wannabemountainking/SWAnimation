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
    // MARK: - 샘플 데이터
    /// 샘플 상품데이터 - 실제 앱에서는 API, JSON 파일로 사용해야 합니다
    private let products = [
        Product(name: "MacBook Pro", price: 2_490_000, icon: "laptopcomputer"),
        Product(name: "iPhone", price: 1_250_000, icon: "iPhone"),
        Product(name: "iPad Air", price: 850_000, icon: "iPad"),
        Product(name: "AirPods", price: 350_000, icon: "airpodspro")
    ]
    
    // MARK: - 상태 관리 값
    /// 현재 장바구니 화면 표시 여부
    @State private var showingCart: Bool = false
    /// 장바구니에 담긴 상품 목록
    @State private var cartItems: [CartItem] = []
    /// MGE를 위한 네임스페이스
    @Namespace private var shoppingNamespace
    /// 토스트 메니저 인스턴스
    @State private var toastManager: ToastManager = .init()
    
    var body: some View {
        ZStack {
            // MARK: - 조건부 화면 렌더링
            if !showingCart {
                // 상품 목록 화면
                ProductListView()
            } else {
                // 장바구니 화면
            }
            
        } //:ZSTACK
    }
}

// MARK: - 상품 목록 화면
/// 상품을 표시하고 장바구니에 추가할 수 있는 화면
struct ProductListView: View {
    var body: some View {
        Text("상품 목록 화면")
    }
}

// MARK: - 상품 카드 컴포넌트
/// 상품 목록에서 각 상품을 표시하는 카드 컴포넌트
struct ProductCard: View {
    // properties
    let product: Product // 표시할 상품 정보
    let namespace: Namespace.ID // Hero Animation 연결용 네임스페이스
    let onAddToCart: () -> Void // 장바구니 추가 콜백(ProductCard를 누르면 cartItems에 추가되도록)
    
    var body: some View {
        VStack(spacing: 15) {
            // 상품 아이콘
            Image(systemName: product.icon)
                .font(.system(size: 40))
                .foregroundStyle(.accent)
                .matchedGeometryEffect(id: "\(product.id)-icon", in: namespace)
            // 상품명
            Text(product.name)
                .font(.headline)
                .fontWeight(.semibold)
                .matchedGeometryEffect(id:"\(product.id)-name", in: namespace)
            // 상품 가격 - formatted() 메서드로 천 단위 구분 쉼표 자동 적용
            Text("₩\(product.price.formatted())")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.accent)
                .matchedGeometryEffect(id: "\(product.id)-price", in: namespace)
            // 장바구니 추가 버튼
            Button {
                // Action - 상위 뷰로 액션 전달
                onAddToCart()
            } label: {
                Text("담기")
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .foregroundStyle(.white)
                    .background(.accent)
                    .cornerRadius(10)
            }
        } //:VSTACK
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
                .matchedGeometryEffect(id: "\(product.id)-background", in: namespace)
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
        )
    }
}

// MARK: - 장바구니 화면
/// 장바구니 아이템들을 관리하는 메인 화면
struct CartView: View {
    var body: some View {
        Text("장바구니 화면")
    }
}

// MARK: - 장바구니 아이템 행 컴포넌트
/// 장바구니 상품 행을 표시
struct CartItemRow: View {
    var body: some View {
        Text("장바구니 아이템 컴포넌트")
    }
}

// MARK: - 프리뷰

#Preview("Main") {
    ShoppingCartMGE()
}

#Preview("Product Card") {
    @Previewable @Namespace var namespace // 프리뷰용 네임스페이스
    let product = Product(name: "MacBook Pro", price: 2_490_000, icon: "laptopcomputer")
    return ProductCard(
        product: product,
        namespace: namespace,
        onAddToCart: { }
    )
}
