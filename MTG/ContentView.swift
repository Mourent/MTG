import SwiftUI

struct MTGCardView: View {
    var card: MTGCard
    
    var body: some View {
        VStack {
            // Tampilkan gambar kartu
            AsyncImage(url: URL(string: card.image_uris?.large ?? "")) { phase in
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
            
            // Tampilkan nama kartu
            Text(card.name)
                .font(.title)
                .padding()
            
            // Tampilkan jenis kartu dan teks orakel
            VStack(alignment: .leading) {
                Text("Type: \(card.type_line)")
                Text("Oracle Text: \(card.oracle_text)")
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("Legalities:")
                    .font(.headline)
                Text("Standard: \(card.legalities.standard)")
                Text("Future: \(card.legalities.future)")
                Text("Historic: \(card.legalities.historic)")
                Text("gladiator: \(card.legalities.gladiator)")
                Text("pioneer: \(card.legalities.pioneer)")
                Text("explorer: \(card.legalities.explorer)")
                Text("modern: \(card.legalities.modern)")
                Text("legacy: \(card.legalities.legacy)")
                Text("Historic: \(card.legalities.historic)")
                Text("Historic: \(card.legalities.historic)")
                Text("Historic: \(card.legalities.historic)")
                Text("Historic: \(card.legalities.historic)")
                Text("Historic: \(card.legalities.historic)")
            }
            .padding()
        }
    }
}

struct ContentView: View {
    @State private var mtgCards: [MTGCard] = []

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
                    ForEach(mtgCards) { card in
                        NavigationLink(destination: MTGCardView(card: card)) {
                            VStack {
                                // Display the small image of the card
                                AsyncImage(url: URL(string: card.image_uris?.normal ?? "")) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 100) // Adjust the size as needed
                                    case .empty:
                                        // Placeholder image or loading indicator
                                        Text("Loading...")
                                    case .failure:
                                        // Placeholder image or error message
                                        Text("Failed to load image")
                                    @unknown default:
                                        // Placeholder image or generic message
                                        Text("An unknown error occurred")
                                    }
                                }
                                .padding(8) // Adjust the overall padding

                                // Display the name of the card
                                Text(card.name)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 4)
                            }
                        }
                    }
                }
                .padding(16)
            }
            .onAppear {
                // Load data dari file JSON
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
    
    // Fungsi untuk memuat data dari file JSON
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
