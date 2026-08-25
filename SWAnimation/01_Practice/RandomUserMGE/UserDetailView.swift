//
//  UserDetailView.swift
//  SWAnimation
//
//  Created by YoonieMac on 8/24/26.
//

import SwiftUI

/// 선택된 사용자의 상세 정보를 표시하는 화면
struct UserDetailView: View {
    // Property
    /// 표시할 사용자 정보
    let user: User
    /// UserCard와 동일한 네임스페이스를 사용하여 연결
    let namespace: Namespace.ID
    /// 뒤로가기 버튼 클릭 시 실행할 클로저
    let onClose: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.ppink, Color.ppurple1, Color.ppurple2]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Content
            VStack(spacing: 25) {
                // 1. 헤더 영역
                HStack(spacing: 10) {
                    Button {
                        // Action
                        withAnimation(.spring) {
                            onClose()
                        }
                    } label: {
                        Text("← Back")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                    
                    // UUID 정보 표시
                    Text("ID \(String(user.id.uuidString.prefix(8)))")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                } //:HSTACK
                .padding(.horizontal)
                .padding(.top, 20)
            
                // 2. 사용자 정보 카드
                VStack(spacing: 25) {
                    // 확대된 프로필 사진
                    AsyncImage(url: URL(string: user.picture.large)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .matchedGeometryEffect(id: "\(user.id)-avator", in: namespace)
                            .overlay {
                                Circle()
                                    .stroke(.white.opacity(0.5), lineWidth: 5)
                            }
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 150, height: 150)
                            .overlay {
                                ProgressView()
                                    .tint(.white)
                                    .scaleEffect(1.5)
                            }
                            .matchedGeometryEffect(id: "\(user.id)-avator", in: namespace)
                    }
                    
                    // 기본 정보 영역
                    VStack(spacing: 10) {
                        // 사용자 이름
                        Text(user.name.fullName)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .matchedGeometryEffect(id: "\(user.id)-name", in: namespace)
                        // 사용자 위치 정보
                        Text(user.location.address)
                            .font(.title3)
                            .foregroundStyle(.white.opacity(0.8))
                            .matchedGeometryEffect(id: "\(user.id)-location", in: namespace)
                        // 나이 정보
                        Text("Age \(user.dob.age)")
                            .font(.headline)
                            .foregroundStyle(.white.opacity(0.5))
                            .matchedGeometryEffect(id: "\(user.id)-age", in: namespace)
                    } //:VSTACK
                    
                    // 3. 세부 정보 그리드
                    LazyVGrid(
                        columns: Array(
                            repeating: GridItem(.flexible()),
                            count: 2
                        ),
                        spacing: 16,
                        content: {
                            // 이메일 정보
                            InfoItem(
                                icon: "envelope",
                                title: "Email",
                                value: user.email
                            )
                            // 전화번호 정보
                            InfoItem(
                                icon: "phone",
                                title: "Phone",
                                value: user.phone
                            )
                            // 성별 정보
                            InfoItem(
                                icon: "person",
                                title: "Gender",
                                value: user.gender
                            )
                            // 국가 정보
                            InfoItem(
                                icon: "globe",
                                title: "Country",
                                value: user.location.country
                            )
                        }
                    )
                } //:VSTACK
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.black.opacity(0.3))
                        .matchedGeometryEffect(id: "\(user.id)-background", in: namespace)
                )
                .padding(.horizontal)
                
                Spacer()
            } //:VSTACK
        } //:ZSTACK
    }
}

struct InfoItem: View {
    let icon: String // 아이콘 이름
    let title: String // 정보 제목
    let value: String // 실제 정보 값
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white.opacity(0.8))
            Text(title)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
            Text(value)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .lineLimit(1)
                .multilineTextAlignment(.center)
        } //:VSTACK
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.3))
        )
    }
}

#Preview {
    @Previewable @Namespace var namespace
    let user = UserService.mockUsers[0]
    
    UserDetailView(
        user: user,
        namespace: namespace,
        onClose: { }
    )
}

#Preview("Info Item") {
    InfoItem(
        icon: "envelope",
        title: "Email",
        value: "user@example.com"
    )
    .background(Color.accentColor)
}
