import SwiftUI

struct CardImageView: View {
    var imageURL: String?

    var body: some View {
        if let imageURL = imageURL {
            AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.red)
                case .empty:
                    ProgressView()
                @unknown default:
                    ProgressView()
                }
            }
        } else {
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray)
        }
    }
}

struct MTGCardView: View {
    var card: MTGCard
    
    var body: some View {
        VStack {
            CardImageView(imageURL: card.image_uris?.large)
                .padding()

            Text(card.name)
                .font(.title)
                .padding()

            VStack(alignment: .leading) {
                Text("Type: \(card.type_line)")
                Text("Oracle Text: \(card.oracle_text)")
            }
            .padding()
        }
        .navigationBarTitle(Text(card.name), displayMode: .inline)
    }
}

struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            TextField("Search...", text: $searchText)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 10)

            Button(action: {
                searchText = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .padding(8)
            }
            .padding(.trailing, 10)
            .opacity(searchText.isEmpty ? 0 : 1)
        }
    }
}

struct ContentView: View {
    @State private var mtgCards: [MTGCard] = []
    @State private var searchText: String = ""
    @State private var isAscendingOrder: Bool = true

    var filteredAndSortedCards: [MTGCard] {
        let filteredCards: [MTGCard]
        if searchText.isEmpty {
            filteredCards = mtgCards
        } else {
            filteredCards = mtgCards.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }

        return filteredCards.sorted { card1, card2 in
            // Adjust the sorting condition based on your needs
            if isAscendingOrder {
                return card1.name < card2.name
            } else {
                return card1.name > card2.name
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $searchText)
                    .padding()

                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
                        ForEach(filteredAndSortedCards) { card in
                            NavigationLink(destination: MTGCardView(card: card)) {
                                VStack {
                                    CardImageView(imageURL: card.image_uris?.large)
                                        .frame(width: 80, height: 120)

                                    Text(card.name)
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 8)
                                }
                                .padding()
                            }
                        }
                    }
                    .padding()
                }
            }
            .onAppear {
                // Load data from JSON file
                if let data = loadJSON() {
                    do {
                        let decoder = JSONDecoder()
                        let cards = try decoder.decode(MTGCardList.self, from: data)
                        mtgCards = cards.data
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }
            .navigationBarTitle("MTG Cards")
            .navigationBarItems(trailing:
                Button(action: {
                    // Toggle sorting order
                    isAscendingOrder.toggle()
                }) {
                    Image(systemName: isAscendingOrder ? "arrow.down.circle" : "arrow.up.circle")
                }
            )
        }
    }

    func loadJSON() -> Data? {
        if let path = Bundle.main.path(forResource: "WOT-Scryfall", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                print("Error loading JSON: \(error)")
            }
        }
        return nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
