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
    @State private var pencet:Bool = false
    var card: MTGCard
    
    var body: some View {
        VStack {
            CardImageView(imageURL: card.image_uris?.normal)
                .scaledToFill()
                .frame(width: .infinity, height: 300, alignment: .top)
                .padding(.top, -80)
                .clipped() 
                .onTapGesture {
                    pencet.toggle()
                }

            Text(card.name)
                .font(.title)
                .fontWeight(.bold)
                
            Text(card.type_line)
                .fontWeight(.bold)
            
            VStack(alignment: .leading) {
                Text(card.oracle_text)
                    .padding(10)
            }
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .shadow(radius: 2)
            .padding()
            
            HStack {
                Button(action: {
                    
                    }) {
                        Text("Versions")
                            .padding(10)
                            .frame(width: 120)
                            .foregroundColor(.gray)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }.buttonStyle(PlainButtonStyle())
                
                    Button(action: {
                        
                    }) {
                        Text("Ruling")
                            .padding(10)
                            .frame(width: 120)
                            .foregroundColor(.gray)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }.buttonStyle(PlainButtonStyle())
            }
            
        }
        .popover(isPresented: $pencet) {
            CardImageView(imageURL: card.image_uris?.large)
        }
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
    @State private var sortOption: SortOption = .name // Default sorting by name

    enum SortOption {
        case name
        case collectorNumber
    }

    var filteredAndSortedCards: [MTGCard] {
        let filteredCards: [MTGCard]
        if searchText.isEmpty {
            filteredCards = mtgCards
        } else {
            filteredCards = mtgCards.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }

        return filteredCards.sorted { card1, card2 in
            switch sortOption {
            case .name:
                return card1.name < card2.name
            case .collectorNumber:
                return card1.collector_number < card2.collector_number
            }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
            VStack {
                SearchBar(searchText: $searchText)
                    .padding()
            HStack {
                Button(action: {
                    sortOption = .name
                    }) {
                        Text("Sort by Name")
                            .padding(10)
                            .foregroundColor(sortOption == .name ? .white : .gray)
                            .background(sortOption == .name ? Color.black : Color(.systemGray6))
                            .cornerRadius(8)
                    }.buttonStyle(PlainButtonStyle())
                
                    Button(action: {
                        sortOption = .collectorNumber
                    }) {
                        Text("Sort by Number")
                            .padding(10)
                            .foregroundColor(sortOption == .collectorNumber ? .white : .gray)
                            .background(sortOption == .collectorNumber ? Color.black : Color(.systemGray6))
                            .cornerRadius(8)
                    }.buttonStyle(PlainButtonStyle())
            }
                
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
                        ForEach(filteredAndSortedCards) { card in
                            NavigationLink(destination: MTGCardView(card: card)) {
                                VStack {
                                    CardImageView(imageURL: card.image_uris?.normal)
                                        .aspectRatio(contentMode: .fit)

                                    Text(card.name)
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 8)
                                        .foregroundColor(.black)
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
