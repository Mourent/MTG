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
    @State private var cards: [MTGCard] = []
    @State private var pencet:Bool = false
    @State private var rulingInfo:Bool = false
    @State private var version:Bool = true
    @State private var selectedCardIndex:Int = 0
    
    var card: MTGCard

    
    var manaArray: [String] {
        var array: [String] = []
        let manaCostCharacters = Array(card.mana_cost)
        
        for index in stride(from: 0, to: manaCostCharacters.count, by: 3) {
            let endIndex = min(index + 3, manaCostCharacters.count)
            let chunk = String(manaCostCharacters[index..<endIndex])
            array.append(chunk)
        }
        return array
    }
    
    var body: some View {
        NavigationView{
            ScrollView{
                ZStack{
                    VStack {
                        VStack{
                            CardImageView(imageURL: card.image_uris?.normal)
                                .scaledToFill()
                                .frame(width: .infinity, height: 300, alignment: .top)
                                .padding(.top, -80)
                                .clipped()
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    pencet.toggle()
                                }
                            
                            HStack{
                                VStack{
                                    VStack{
                                        Text(card.name)
                                            .font(.system(size: 23))
                                            .fontWeight(.bold)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    VStack{
                                        Text(card.type_line)
                                            .fontWeight(.bold)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.leading, 25)
                                .padding(.bottom, -15)
                                
                                HStack{
                                    ForEach(manaArray, id: \.self) { cek in
                                        if cek == "{1}" {
                                            Image("1")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .shadow(radius: 4)
                                        }
                                        else if cek == "{2}" {
                                            Image("2")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .shadow(radius: 4)
                                        }
                                        else if cek == "{3}" {
                                            Image("3")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .shadow(radius: 4)
                                        }
                                        else if cek == "{4}" {
                                            Image("4")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .shadow(radius: 4)
                                        }
                                        else if cek == "{7}" {
                                            Image("7")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .shadow(radius: 4)
                                        }
                                        else if cek == "{B}" {
                                            Image("B")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .shadow(radius: 4)
                                        }
                                        else if cek == "{G}" {
                                            Image("G")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .shadow(radius: 4)
                                        }
                                        else if cek == "{R}" {
                                            Image("R")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .shadow(radius: 4)
                                        }
                                        else if cek == "{U}" {
                                            Image("U")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .shadow(radius: 4)
                                        }
                                        else if cek == "{W}" {
                                            Image("W")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .shadow(radius: 4)
                                        }
                                    }
                                }
                                .padding(.trailing, 25)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(card.oracle_text)
                                    .padding(10)
                            }
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .clipShape(RoundedCorner(radius: 15, corners: [.bottomLeft, .bottomRight]))
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                        
                        HStack {
                            Button(action: {
                                showPreviousCard()
                            }) {
                                Image(systemName: "arrow.left")
                            }
                            Button(action: {
                                versionInfo()
                            }) {
                                Text("Versions")
                                    .padding(10)
                                    .frame(width: 120)
                                    .foregroundColor(version ==  true ? .white : .gray)
                                    .background(version ==  true ? .red : .clear)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(version ? Color.red : Color.gray, lineWidth: 1)
                                    )
                            }.buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                fetchRulingInfo()
                            }) {
                                Text("Ruling")
                                    .padding(10)
                                    .frame(width: 120)
                                    .foregroundColor(rulingInfo ==  true ? .white : .gray)
                                    .background(rulingInfo ==  true ? .red : .clear)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(rulingInfo ? Color.red : Color.gray, lineWidth: 1)
                                    )
                            }.buttonStyle(PlainButtonStyle())
                            Button(action: {
                                showNextCard()
                            }) {
                                Image(systemName: "arrow.right")
                            }
                        }
                        .padding(.top)
                    }
                    
                    if pencet {
                        Color.black.opacity(0.8)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                // Dismiss the large image popup when tapped
                                pencet = false
                            }
                        
                        if let largeImageURL = card.image_uris?.large {
                            // Display a larger image as a popup overlay
                            AsyncImage(url: URL(string: largeImageURL)) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .cornerRadius(16)
                                        .padding(20)
                                case .failure:
                                    // Handle failure, you can display an error image or message
                                    Image(systemName: "exclamationmark.triangle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.red)
                                        .padding()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .cornerRadius(16)
                                        .padding(20)
                                case .empty:
                                    // Placeholder or loading indicator
                                    ProgressView()
                                        .padding()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .cornerRadius(16)
                                        .padding(20)
                                @unknown default:
                                    // Handle unknown state
                                    ProgressView()
                                        .padding()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .cornerRadius(16)
                                        .padding(20)
                                }
                            }
                        }
                    }
                }
                
                if version == true{
                    HStack{
                        Text("PRICES FROM")
                            .padding()
                            .foregroundColor(.red)
                            .fontWeight(.heavy)
                        
                        Image(systemName: "storefront")
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack{
                        let setUpper = card.set.uppercased()
                        
                        Text("\(card.set_name) (\(setUpper))")
                            .font(.system(size: 18))
                            .padding(8)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .background(.red)
                    
                    HStack(spacing: 3){
                        CardImageView(imageURL: card.image_uris?.small)
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        
                        VStack(alignment: .trailing){
                            Text("RETAIL")
                                .fontWeight(.heavy)
                                .foregroundColor(.green)
                            Text("BUYLIST")
                                .fontWeight(.heavy)
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 25)
                        
                        Spacer().frame(width: 25)
                        
                        VStack{
                            Text("Normal")
                                .fontWeight(.heavy)
                            Text("$\(card.prices.usd)")
                            Text("$0.75")
                        }
                        
                        Spacer().frame(width: 25)
                        
                        VStack{
                            Text("Foil")
                                .fontWeight(.heavy)
                                .foregroundColor(.yellow)
                            Text("$\(card.prices.usd_foil)")
                            Text("$2.50")
                        }
                    }
                    .frame(width: 360)
                    .padding([.top, .bottom])
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                if rulingInfo == true{
                    HStack{
                        Text("LEGALITIES")
                            .padding()
                            .foregroundColor(.red)
                            .fontWeight(.heavy)
                    }
                    HStack{
                        VStack(alignment: .leading, spacing: 10) {
                            HStack{
                                Text(card.legalities.standard == "not_legal" ? "Not Legal" : "Legal")
                                    .frame(width: 75)
                                    .padding(10)
                                    .background(card.legalities.standard == "not_legal" ? Color(.systemGray6) : Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(card.legalities.standard == "not_legal" ? .black : Color.white)
                                Text("Standart")
                                    .frame(width: 70, alignment: .leading)
                            }
                            HStack{
                                Text(card.legalities.future == "not_legal" ? "Not Legal" : "Legal")
                                    .frame(width: 75)
                                    .padding(10)
                                    .background(card.legalities.future == "not_legal" ? Color(.systemGray6) : Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(card.legalities.future == "not_legal" ? .black : Color.white)
                                Text("Future")
                                    .frame(width: 70, alignment: .leading)
                            }
                            HStack{
                                Text(card.legalities.historic == "not_legal" ? "Not Legal" : "Legal")
                                    .frame(width: 75)
                                    .padding(10)
                                    .background(card.legalities.historic == "not_legal" ? Color(.systemGray6) : Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(card.legalities.historic == "not_legal" ? .black : Color.white)
                                Text("Historic")
                                    .frame(width: 70, alignment: .leading)
                            }
                            HStack{
                                Text(card.legalities.gladiator == "not_legal" ? "Not Legal" : "Legal")
                                    .frame(width: 75)
                                    .padding(10)
                                    .background(card.legalities.gladiator == "not_legal" ? Color(.systemGray6) : Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(card.legalities.gladiator == "not_legal" ? .black : Color.white)
                                Text("Gladiator")
                                    .frame(width: 70, alignment: .leading)
                            }
                            HStack{
                                Text(card.legalities.pioneer == "not_legal" ? "Not Legal" : "Legal")
                                    .frame(width: 75)
                                    .padding(10)
                                    .background(card.legalities.pioneer == "not_legal" ? Color(.systemGray6) : Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(card.legalities.pioneer == "not_legal" ? .black : Color.white)
                                Text("Pioneer")
                                    .frame(width: 70, alignment: .leading)
                            }
                            HStack{
                                Text(card.legalities.modern == "not_legal" ? "Not Legal" : "Legal")
                                    .frame(width: 75)
                                    .padding(10)
                                    .background(card.legalities.modern == "not_legal" ? Color(.systemGray6) : Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(card.legalities.modern == "not_legal" ? .black : Color.white)
                                Text("Modern")
                                    .frame(width: 70, alignment: .leading)
                            }
                            HStack{
                                Text(card.legalities.legacy == "not_legal" ? "Not Legal" : "Legal")
                                    .frame(width: 75)
                                    .padding(10)
                                    .background(card.legalities.legacy == "not_legal" ? Color(.systemGray6) : Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(card.legalities.legacy == "not_legal" ? .black : Color.white)
                                Text("Legacy")
                                    .frame(width: 70, alignment: .leading)
                            }
                            HStack{
                                Text(card.legalities.pauper == "not_legal" ? "Not Legal" : "Legal")
                                    .frame(width: 75)
                                    .padding(10)
                                    .background(card.legalities.pauper == "not_legal" ? Color(.systemGray6) : Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(card.legalities.pauper == "not_legal" ? .black : Color.white)
                                Text("Pauper")
                                    .frame(width: 70, alignment: .leading)
                            }
                            HStack{
                                Text(card.legalities.vintage == "not_legal" ? "Not Legal" : "Legal")
                                    .frame(width: 75)
                                    .padding(10)
                                    .background(card.legalities.vintage == "not_legal" ? Color(.systemGray6) : Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(card.legalities.vintage == "not_legal" ? .black : Color.white)
                                Text("Vintage")
                                    .frame(width: 70, alignment: .leading)
                            }
                            HStack{
                                Text(card.legalities.penny == "not_legal" ? "Not Legal" : "Legal")
                                    .frame(width: 75)
                                    .padding(10)
                                    .background(card.legalities.penny == "not_legal" ? Color(.systemGray6) : Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(card.legalities.penny == "not_legal" ? .black : Color.white)
                                Text("Penny")
                                    .frame(width: 70, alignment: .leading)
                            }
                        }
                        VStack(alignment: .leading, spacing: 10){
                            HStack{
                                Text(card.legalities.commander == "not_legal" ? "Not Legal" : "Legal")
                                    .frame(width: 75)
                                    .padding(10)
                                    .background(card.legalities.commander == "not_legal" ? Color(.systemGray6) : Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(card.legalities.commander == "not_legal" ? .black : Color.white)
                                Text("Commander")
                                    .frame(width: 70, alignment: .leading)
                            }
                            HStack{
                                Text(card.legalities.oathbreaker == "not_legal" ? "Not Legal" : "Legal")
                                    .frame(width: 75)
                                    .padding(10)
                                    .background(card.legalities.oathbreaker == "not_legal" ? Color(.systemGray6) : Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(card.legalities.oathbreaker == "not_legal" ? .black : Color.white)
                                Text("Oathbreaker")
                                    .frame(width: 70, alignment: .leading)
                            }
                            HStack{
                                Text(card.legalities.brawl == "not_legal" ? "Not Legal" : "Legal")
                                    .frame(width: 75)
                                    .padding(10)
                                    .background(card.legalities.brawl == "not_legal" ? Color(.systemGray6) : Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(card.legalities.brawl == "not_legal" ? .black : Color.white)
                                Text("Brawl")
                                    .frame(width: 70, alignment: .leading)
                            }
                            HStack{
                                Text(card.legalities.historicbrawl == "not_legal" ? "Not Legal" : "Legal")
                                    .frame(width: 75)
                                    .padding(10)
                                    .background(card.legalities.historicbrawl == "not_legal" ? Color(.systemGray6) : Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(card.legalities.historicbrawl == "not_legal" ? .black : Color.white)
                                Text("Historic Brawl")
                                    .frame(width: 70, alignment: .leading)
                            }
                            HStack{
                                Text(card.legalities.alchemy == "not_legal" ? "Not Legal" : "Legal")
                                    .frame(width: 75)
                                    .padding(10)
                                    .background(card.legalities.alchemy == "not_legal" ? Color(.systemGray6) : Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(card.legalities.alchemy == "not_legal" ? .black : Color.white)
                                Text("Alchemy")
                                    .frame(width: 70, alignment: .leading)
                            }
                            HStack{
                                Text(card.legalities.paupercommander == "not_legal" ? "Not Legal" : "Legal")
                                    .frame(width: 75)
                                    .padding(10)
                                    .background(card.legalities.paupercommander == "not_legal" ? Color(.systemGray6) : Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(card.legalities.paupercommander == "not_legal" ? .black : Color.white)
                                Text("Pauper Cmdr.")
                                    .frame(width: 70, alignment: .leading)
                            }
                            HStack{
                                Text(card.legalities.duel == "not_legal" ? "Not Legal" : "Legal")
                                    .frame(width: 75)
                                    .padding(10)
                                    .background(card.legalities.duel == "not_legal" ? Color(.systemGray6) : Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(card.legalities.duel == "not_legal" ? .black : Color.white)
                                Text("Duel")
                                    .frame(width: 70, alignment: .leading)
                            }
                            HStack{
                                Text(card.legalities.oldschool == "not_legal" ? "Not Legal" : "Legal")
                                    .frame(width: 75)
                                    .padding(10)
                                    .background(card.legalities.oldschool == "not_legal" ? Color(.systemGray6) : Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(card.legalities.oldschool == "not_legal" ? .black : Color.white)
                                Text("Old School")
                                    .frame(width: 70, alignment: .leading)
                            }
                            HStack{
                                Text(card.legalities.premodern == "not_legal" ? "Not Legal" : "Legal")
                                    .frame(width: 75)
                                    .padding(10)
                                    .background(card.legalities.premodern == "not_legal" ? Color(.systemGray6) : Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(card.legalities.premodern == "not_legal" ? .black : Color.white)
                                Text("Pre Modern")
                                    .frame(width: 70, alignment: .leading)
                            }
                            HStack{
                                Text(card.legalities.predh == "not_legal" ? "Not Legal" : "Legal")
                                    .frame(width: 75)
                                    .padding(10)
                                    .background(card.legalities.predh == "not_legal" ? Color(.systemGray6) : Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(card.legalities.predh == "not_legal" ? .black : Color.white)
                                Text("Predh")
                                    .frame(width: 70, alignment: .leading)
                            }
                        }
                    }
                }
            }
        }.navigationBarTitle("", displayMode: .inline)
    }
    
    func fetchRulingInfo() {
        rulingInfo = true
        version = false
    }
    func versionInfo() {
        version = true
        rulingInfo = false
    }
    func showNextCard() {
        selectedCardIndex = (selectedCardIndex + 1) % cards.count
    }

    // Function to display the previous card
    func showPreviousCard() {
        selectedCardIndex = (selectedCardIndex - 1 + cards.count) % cards.count
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let cornerRadii = CGSize(width: radius, height: radius)
        let roundedRect = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: cornerRadii)

        path.addPath(Path(roundedRect.cgPath))
        return path
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
                .overlay(
                    HStack {
                        Spacer()

                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(8)
                        }
                    }
                        .padding(.trailing, 15)
                    .opacity(searchText.isEmpty ? 0 : 1)
                )
        }
    }
}

struct ContentView: View {
    @State private var mtgCards: [MTGCard] = []
    @State private var searchText: String = ""
    @State private var sortOption: SortOption = .name // Default sorting by name

    enum SortOption {
        case name
        case nameDesc
        case collectorNumber
        case collectorNumberDesc
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
            case .nameDesc:
                return card1.name > card2.name
            case .collectorNumber:
                let number1 = Int(card1.collector_number) ?? 0
                let number2 = Int(card2.collector_number) ?? 0
                return number1<number2
            case .collectorNumberDesc:
                let number1 = Int(card1.collector_number) ?? 0
                let number2 = Int(card2.collector_number) ?? 0
                return number1>number2
            }
        }
    }

    var body: some View {
        TabView{
            NavigationView {
                ScrollView {
                    VStack {
                        SearchBar(searchText: $searchText)
                            .padding()
                        HStack {
                            Button(action: {
                                if sortOption == .name {
                                    // Toggle between ascending and descending order
                                    sortOption = sortOption == .name ? .nameDesc : .name
                                } else {
                                    sortOption = .name
                                }
                            }) {
                                HStack{
                                    Text("Sort by Name")
                                    if sortOption == .name {
                                        Image(systemName: "arrow.up")
                                    } else if sortOption == .nameDesc {
                                        Image(systemName: "arrow.down")
                                    }
                                }
                                .padding(10)
                                .frame(width: 175)
                                .foregroundColor(sortOption == .name || sortOption == .nameDesc ? .white : .gray)
                                .background(sortOption == .name || sortOption == .nameDesc ? Color.black : Color(.systemGray6))
                                .cornerRadius(8)
                            }.buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                if sortOption == .collectorNumber {
                                    // Toggle between ascending and descending order
                                    sortOption = sortOption == .collectorNumber ? .collectorNumberDesc : .collectorNumber
                                } else {
                                    sortOption = .collectorNumber
                                }
                            }) {
                                HStack{
                                    Text("Sort by Number")
                                    if sortOption == .collectorNumber {
                                        Image(systemName: "arrow.up")
                                    } else if sortOption == .collectorNumberDesc {
                                        Image(systemName: "arrow.down")
                                    }
                                }
                                .padding(10)
                                .frame(width: 175)
                                .foregroundColor(sortOption == .collectorNumber || sortOption == .collectorNumberDesc ? .white : .gray)
                                .background(sortOption == .collectorNumber || sortOption == .collectorNumberDesc ? Color.black : Color(.systemGray6))
                                .cornerRadius(8)
                            }.buttonStyle(PlainButtonStyle())
                        
                        }
                        
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
                            ForEach(filteredAndSortedCards) { card in
                                NavigationLink(destination: MTGCardView(card: card)) {
                                    VStack {
                                        CardImageView(imageURL: card.image_uris?.normal)
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height:150)
                                            .clipped()
                                            
                                        Text(card.name)
                                            .font(.caption)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(nil)
                                            .padding(.horizontal, 8)
                                            .foregroundColor(.black)
                                            .frame(height:50)
                                    }
                                    .padding()
                                    .frame(height: 200)
                                    .padding(.top, 10)
                                }
                            }
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
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
                .navigationTitle("MTG Cards")
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            .tag(0)
            .toolbarBackground(.white, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            
            Text("Hello World!")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(1)
            Text("Hello World!")
                .tabItem {
                    Image(systemName: "folder")
                    Text("Collection")
                }
                .tag(2)
            Text("Hello World!")
                .tabItem {
                    Image(systemName: "lanyardcard")
                    Text("Decks")
                }
                .tag(3)
            Text("Hello World!")
                .tabItem {
                    Image(systemName: "camera")
                    Text("Scan")
                }
                .tag(4)
        }
        .accentColor(.black)
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
