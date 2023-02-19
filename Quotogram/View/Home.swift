//
//  Home.swift
//  Quotogram
//
//  Created by MAC on 20/03/22.
//

import SwiftUI

struct Home: View {
    
    @State var cards: [Card] = [
        Card(cardColor: .blue, date: "Hirunaka no Ryuusei", title: "Thinking about whether it\'s because of jealousy or just saying it out loud by accident, aren\'t they all part of love? Love isn\'t always sweet. "),
        Card(cardColor: .red, date: "Monday 8th November", title: "hello there is new"),
        Card(cardColor: .yellow, date: "Amelie Earhart", title: "The  most beautiful thing is the decision to act."),
        Card(cardColor: .cyan, date: "Leonardo", title: "Let us not take this planet for granted, I do not take tonight for granted"),
        Card(cardColor: .green, date: "Johnny Deep", title: "Awards are not important to me when I see a 10 year old boy saying I love Captain Jack Sparrow")
    ]
    
    @State var backgroundColor: Color = .clear
    
    @State var showDetailPage: Bool = false
    @State var currentCard: Card?
    
    @Namespace var animation
    
    @State var showDetailContent: Bool = false
    
    var body: some View {
        
        VStack {
            HStack(alignment: .bottom) {
                VStack(alignment: .center) {
                    Text("QUOTE-OGRAM")
                        .font(.largeTitle.bold())
                }
            }
            GeometryReader { proxy in
                let size = proxy.size
                
                let trailingCardsToShown: CGFloat = 2
                let trailingSpaceOfEachCards: CGFloat = 20
                
                ZStack {
                    ForEach(cards) { card in
                        InfiniteStackedCards(cards: $cards, backgroundColor: $backgroundColor, card: card, trailingCardsToShown: trailingCardsToShown, trailingSpaceOfEachCards: trailingSpaceOfEachCards, animation: animation, showDetailPage: $showDetailPage)
                            .onTapGesture {
                                withAnimation(.spring()){
                                    currentCard = card
                                    showDetailPage = true
                                }
                            }
                    }
                }
                .padding(.leading,10)
                .padding(.trailing,(trailingCardsToShown * trailingSpaceOfEachCards))
                .frame(height: size.height / 1.6)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay(
            DetailPage()
        )
        .background(
            LinearGradient(gradient: Gradient(colors: [self.backgroundColor.opacity(0.75), .black]), startPoint: .top, endPoint: .bottom)
        )
        .onAppear{
            self.backgroundColor = self.cards.first?.cardColor ?? .clear
        }
    }
    
    @ViewBuilder
    private func DetailPage() -> some View {
        ZStack {
            if let currentCard = currentCard, showDetailPage {
                
                Rectangle()
                    .fill(currentCard.cardColor)
                    .matchedGeometryEffect(id: currentCard.id, in: animation)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 15) {
                    Button {
                        withAnimation {
                            showDetailContent = false
                            showDetailPage = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.white.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(currentCard.date)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .padding(.top)
                    
                    Text(currentCard.title)
                        .font(.title.bold())
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        Text(a)
                            .padding(.top)
                    }
                }
                .opacity(showDetailContent ? 1 : 0)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation {
                            showDetailContent = true
                        }
                    }
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct InfiniteStackedCards: View {
    @Binding var cards: [Card]
    @Binding var backgroundColor: Color
    var card: Card
    var trailingCardsToShown: CGFloat
    var trailingSpaceOfEachCards: CGFloat
    
    var animation: Namespace.ID
    @Binding var showDetailPage: Bool
    
    @GestureState var isDragging: Bool = false
    @State var offset: CGFloat = .zero
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(card.date)
                .font(.caption)
                .fontWeight(.semibold)
            Text(card.title)
                .font(.title.bold())
                .padding(.top)
            
            Spacer()
            
            Label{
                Image(systemName: "arrow.right")
            } icon: {
                Text("Read More")
            }
            .font(.system(size: 15, weight: .semibold))
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .padding(.vertical,10)
        .foregroundColor(.white)
        
        .background{
            
            ZStack{
                RoundedRectangle(cornerRadius: 25)
                    .fill(card.cardColor)
                    .matchedGeometryEffect(id: card.id, in: animation)
            }
        }
        .padding(.trailing,-getPadding())
        .padding(.vertical,getPadding())
        .zIndex(Double(CGFloat(cards.count) - getIndex()))
        .rotationEffect(.init(degrees: getRotation(angle: 10)))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .offset(x: offset)
        .gesture(
            DragGesture()
                .updating($isDragging, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    var translation = value.translation.width
                    translation = cards.first?.id == card.id ? translation : 0
                    translation = isDragging ? translation : 0
                    translation = (translation < 0 ? translation : 0)
                    offset = translation
                })
                .onEnded({ value in
                    
                    let width = UIScreen.main.bounds.width
                    let cardPassed = -offset > (width/2)
                    
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if cardPassed {
                            offset = -width
                            removeAndPutBack()
                        } else {
                            offset = .zero
                        }
                    }
                })
        )
    }
    
    private func removeAndPutBack() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            var updatedCard = card
            updatedCard.id = UUID().uuidString
            
            cards.append(updatedCard)
            
            withAnimation {
                cards.removeFirst()
                backgroundColor = cards.first?.cardColor ?? .clear
            }
        }
    }
    
    private func getRotation(angle: Double)-> Double {
        let width = UIScreen.main.bounds.width - 50
        let progress = offset / width
        return Double(progress) * angle
    }
    
    private func getPadding() -> CGFloat {
        
        let maxPadding = trailingCardsToShown * trailingSpaceOfEachCards
        
        let cardPadding = getIndex() * trailingSpaceOfEachCards
        
        return (getIndex() <= trailingCardsToShown ? cardPadding : maxPadding)
    }
    
    private func getIndex() -> CGFloat {
        
        let index = cards.firstIndex { card in
            return self.card.id == card.id
        } ?? 0
        
        return CGFloat(index)
    }
}

let a = "hello there Thinking about whether it\'s because of jealousy or just saying it out loud by accident, aren\'t they all part of love? Love isn\'t always sweet. Thinking about whether it\'s because of jealousy or just saying it out loud by accident, aren\'t they all part of love? Love isn\'t always sweet. Thinking about whether it\'s because of jealousy or just saying it out loud by accident, aren\'t they all part of love? Love isn\'t always sweet. Thinking about whether it\'s because of jealousy or just saying it out loud by accident, aren\'t they all part of love? Love isn\'t always sweet. vThinking about whether it\'s because of jealousy or just saying it out loud by accident, aren\'t they all part of love? Love isn\'t always sweet. Thinking about whether it\'s because of jealousy or just saying it out loud by accident, aren\'t they all part of love? Love isn\'t always sweet. Thinking about whether it\'s because of jealousy or just saying it out loud by accident, aren\'t they all part of love? Love isn\'t always sweet. Thinking about whether it\'s because of jealousy or just saying it out loud by accident, aren\'t they all part of love? Love isn\'t always sweet. Thinking about whether it\'s because of jealousy or just saying it out loud by accident, aren\'t they all part of love? Love isn\'t always sweet. Thinking about whether it\'s because of jealousy or just saying it out loud by accident, aren\'t they all part of love? Love isn\'t always sweet. Thinking about whether it\'s because of jealousy or just saying it out loud by accident, aren\'t they all part of love? Love isn\'t always sweet. Thinking about whether it\'s because of jealousy or just saying it out loud by accident, aren\'t they all part of love? Love isn\'t always sweet. Thinking about whether it\'s because of jealousy or just saying it out loud by accident, aren\'t they all part of love? Love isn\'t always sweet. Thinking about whether it\'s because of jealousy or just saying it out loud by accident, aren\'t they all part of love? Love isn\'t always sweet. v v Thinking about whether it\'s because of jealousy or just saying it out loud by accident, aren\'t they all part of love? Love isn\'t always sweet."
