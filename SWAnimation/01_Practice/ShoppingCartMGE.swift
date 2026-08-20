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
        Product(name: "iPhone", price: 1_250_000, icon: "iphone"),
        Product(name: "iPad Air", price: 850_000, icon: "ipad"),
        Product(name: "AirPods", price: 350_000, icon: "airpodspro")
    ]
    
    // MARK: - 상태 관리 값
    /// 현재 장바구니 화면 표시 여부
    @State private var showingCart: Bool = true
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
				ProductListView(
					products: products,
					namespace: shoppingNamespace, // 장바구니 추가 콜백
					cartItems: $cartItems,  // Binding으로 실시간 동기화
					showingCart: $showingCart, // 화면 전환 제어용 Binding
					onAddToCart: { product in
						// TODO: 장바구니 콜백 함수
						addToCart(product)
					}
				)
            } else {
                // 장바구니 화면
				CartView(cartItems: <#Binding<[CartItem]>#>, showingCart: <#Binding<Bool>#>, namespace: <#Namespace.ID#>)
            }
            
			// MARK: - 토스트 오버레이
			VStack(spacing: 10) {
				ForEach(toastManager.activeToasts) { toast in
					ToastView(toast: toast) {
						toastManager.dismissToast(toast)
					}
					.transition(toast.type.transition)
				} //:LOOP
				Spacer()
			} //:VSTACK
			.padding(.top, 50)
			.padding(.horizontal, 20)
        } //:ZSTACK
    }
	
	// MARK: - 장바구니 추가 메서드
	/// 장바구니에 추가할 핵심 함수
	private func addToCart(_ product: Product) {
		withAnimation(.spring) {
			// 이미 장바구니에 있는 상품인지 확인 - 있으면 기존 상품에서 수량만 추가, 없으면 product 추가
			if let existingIndex = cartItems.firstIndex(where: { cartItem in
				cartItem.product.id == product.id
			}) {
				// 기존 상품의 수량만 증가
				cartItems[existingIndex].quantity += 1
			} else {
				// 새로운 상품을 장바구니에 추가
				cartItems.append(CartItem(product: product, quantity: 1))
			}
		}
		// MARK: - 토스트 메시지 표시 - 기존 프로젝트 ToastManager 사용
		/// 사용자에게 즉각적인 피드백 제공 토스트 메시지
		toastManager.showToast(
			type: .success,
			title: "\(product.name) 추가됨",
			message: "장바구니에 상품이 추가되었습니다"
		)
	}
	
	
}

// MARK: - 상품 목록 화면
/// 상품을 표시하고 장바구니에 추가할 수 있는 화면
struct ProductListView: View {
	
	let products: [Product] // 표시할 상품 목록
	let namespace: Namespace.ID // Hero Animation 연결점
	
	@Binding var cartItems: [CartItem] // 장바구니 상태 - 동기화를 위해서 바인딩 처리
	@Binding var showingCart: Bool // 화면 전환 제어 - 바인딩 처리
	
	let onAddToCart: (Product) -> Void // 장바구니 추가 콜백
	
    var body: some View {
		VStack(spacing: 20) {
			// MARK: - 헤더 영역
			HStack(spacing: 10) {
				// 화면 제목
				Text("상품 목록")
					.font(.title)
					.fontWeight(.bold)
					.foregroundStyle(.accent)
				
				Spacer()
				
				// 장바구니 버튼
				Button {
					// Action: 에니메이션과 함께 장바구니 화면으로 전환
					withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
						showingCart = true
					}
				} label: {
					ZStack {
						// 기본 장바구니 아이콘
						Image(systemName: "cart")
							.font(.title2)
							.foregroundStyle(.accent)
						
						// 장바구니 개수 뱃지
						if !cartItems.isEmpty {
							// 조건부 - 아이템이 있을 때만 벳지 표시
							// 전체 수량 계산
							/*
							 Reduce 함수 설명
							 - 초기값 : 0부터 시작
							 - accumulator: 누적 값(지금까지 계산된 총합 - 더 정확히는 직전까지 계산된 총합)
							 - currentItem: 현재 처리 중인 장바구니 아이템
							 - 각 아이템의 quantity를 누적값에 더하면 총 수량이 계산
							 */
							let totalItems = cartItems.reduce(0) { accumulator, currentItem in
								return accumulator + currentItem.quantity
							}
							// 벳지 라벨
							// TODO: - 벳지 레벨 디자인 추가
							Text("\(totalItems)")
								.font(.caption)
								.fontWeight(.bold)
								.foregroundStyle(.white)
								.padding(5)
								.background(Circle().fill(.red))
								.offset(x: 10, y: -10)
						}
					} //:ZSTACK
				}
			} //:HSTACK
			.padding(.horizontal)
			
			// MARK: - 상품 그리드
			/// ScrollView + LazyVGrid 조합으로 화면에 보이는 셀만 먼저 렌더링해서 메모리 효율성 확보
			ScrollView {
				LazyVGrid(
					columns: Array(repeating: GridItem(.flexible()), count: 2),
					content: {
						ForEach(products) { product in
							// 각 상품을 Product Card로 표시
							ProductCard(
								product: product,
								namespace: namespace,
								onAddToCart: {
									onAddToCart(product) // 콜백을 통한 상위 뷰 통신
								}
							)
						} //:LOOP
					}
				) //:GRID
			} //:SCROLL
			.padding(.horizontal)
		} //:VSTACK
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
	// properties
	@Binding var cartItems: [CartItem] // 장바구니 아이템 목록 (양방향 바인딩)
	@Binding var showingCart: Bool // 화면 전환 상태 제어
	let namespace: Namespace.ID
	
    var body: some View {
        Text("장바구니 화면")
    }
}

// MARK: - 장바구니 아이템 행 컴포넌트
/// 장바구니 화면에서 각 아이템을 표시하는 행 컴포넌트
struct CartItemRow: View {
	// properties
	let item: CartItem // 표시할 장바구니 아이탬
	let namespace: Namespace.ID // MGE용 네임 스페이스
	let onCartAction: (CartAction) -> Void // 수량 조절 액션 콜백 클로져
	
	/// 수량 조절 액션 타입 선언
	enum CartAction {
		case increase // 수량 증가
		case decrease // 수량 감소
	}
	
    var body: some View {
		HStack(spacing: 15) {
			// MARK: - 상품 아이콘 영역
			Image(systemName: item.product.icon)
				.font(.system(size: 30))
				.foregroundStyle(Color.accent)
				.frame(width: 50, height: 50)
				.background(
					RoundedRectangle(cornerRadius: 10)
						.fill(Color.accent.opacity(0.1))
				)
				.matchedGeometryEffect(id: "\(item.product.id)-icon", in: namespace)
			
			// MARK: - 상품 정보 영역
			VStack(spacing: 5) {
				// 상품명
				Text(item.product.name)
					.font(.headline)
					.fontWeight(.medium)
					.matchedGeometryEffect(id: "\(item.product.id)-name", in: namespace)
				// 단가 정보
				Text("₩\(item.product.price.formatted())")
					.font(.subheadline)
					.fontWeight(.semibold)
					.foregroundStyle(.accent)
					.matchedGeometryEffect(id: "\(item.product.id)-price", in: namespace)
			} //:VSTACK
			Spacer()
			
			// MARK: - 수량 조절 컨트롤러
			QuantityControl(
				quantity: item.quantity,
				subtotalPrice: item.subtotalPrice,
				onIncrease: {
					onCartAction(.increase)
				},
				onDecrease: {
					onCartAction(.decrease)
				}
			)
		} //:HSTACK
		.padding()
		.background(
			RoundedRectangle(cornerRadius: 15)
				.fill(.white)
				.matchedGeometryEffect(id: "\(item.product.id)-background", in: namespace)
				.shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
		)
    }
}

// MARK: - 수량 조절 컴포넌트
struct QuantityControl: View {
	// properties
	let quantity: Int // 현재 수량
	let subtotalPrice: Int // 한 상품의 가격 * 수량 (단가 * 수량)
	let onIncrease: () -> Void // 수량 증가 함수
	let onDecrease: () -> Void // 수량 감소 함수
	
	var body: some View {
		VStack(spacing: 10) {
			// MARK: - 수량 조절 버튼 그룹
			HStack(spacing: 10) {
				// 수량 감소 버튼
				Button {
					// Action
					onDecrease()
				} label: {
					Text("-")
				}
				.frame(width: 30, height: 30)
				.background(
					Circle()
						.fill(.secondary.opacity(0.2))
				)
				
				// 현재 수량 표시
				Text("\(quantity)")
					.font(.headline)
					.fontWeight(.semibold)
					.frame(width: 30) // 고정 너비로 숫자 변경 시 레이아웃 흔들림 방지
				
				// 수량 증가 버튼
				Button {
					// Action
					onIncrease()
				} label: {
					Text("+")
						.foregroundStyle(.white)
				}
				.frame(width: 30, height: 30)
				.background(
					Circle()
						.fill(.accent)
				)
				
			} //:HSTACK
			
			// MARK: - 개별 상품 당 총 가격 표시
			Text("₩\(subtotalPrice.formatted())")
				.font(.caption)
				.fontWeight(.bold)
				.foregroundStyle(.secondary)
			
		} //:VSTACK
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

#Preview("CartItemRow") {
	@Previewable @Namespace var namespace // 프리뷰용 네임스페이스
	let item = CartItem(
		product: Product(name: "iPad", price: 850_000, icon: "ipad"),
		quantity: 2
	)
	CartItemRow(
		item: item,
		namespace: namespace,
		onCartAction: {_ in }
	)
}
