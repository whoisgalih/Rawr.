//
//  DetailView.swift
//  Rawr
//
//  Created by Galih Akbar on 02/11/24.
//

import CachedAsyncImage
import SwiftUI

enum CoordinateSpaces {
    case scrollView
}

struct DetailView: View {
    @ObservedObject var presenter: DetailPresenter

    @State private var isShowingFullDescription: Bool = false

    var body: some View {
        ScrollView {
            header
            if presenter.isLoading {
                VStack(spacing: 20) {
                    title
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)

                    platformAndRating

                    release

                    loadingIndicator
                }
                .background(Color.white)
            } else if presenter.isError {
                VStack(spacing: 20) {
                    title
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)

                    platformAndRating

                    release

                    errorIndicator
                }
                .background(Color.white)
            } else {
                content
                    .background(Color.white)
            }
        }
        .onAppear {
            if self.presenter.gameDetail == nil {
                self.presenter.getGameDetail()
            }
            if self.presenter.screenshots.isEmpty {
                self.presenter.getScreenshots()
            }

        }
        .navigationBarTitle(Text(self.presenter.game.name), displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: {
                        presenter.updateFavoriteGame()
                        //                        isFavorite.toggle()
                    },
                    label: {
                        Image(systemName: presenter.game.favorite ? "heart.fill" : "heart")
                            .frame(width: 30)
                            .foregroundColor(presenter.game.favorite ? .red : .gray)
                    }
                )
            }
        }
    }
}

extension DetailView {
    var loadingIndicator: some View {
        VStack {
            Text("Loading...")
            ProgressView()
        }
    }

    var errorIndicator: some View {
        CustomEmptyView(
            image: "assetSearchNotFound",
            title: presenter.errorMessage
        ).offset(y: 80)
    }

    var header: some View {
        ParallaxHeader(
            coordinateSpace: CoordinateSpaces.scrollView,
            defaultHeight: 300
        ) {
            if let url = URL(string: presenter.game.backgroundImage) {
                // Load the image from URL if available
                CachedAsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
            } else {
                // Fallback placeholder image
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFill()
            }
        }
    }

    var title: some View {
        Text("\(presenter.game.name)")
            .customFont(.largeTitle, .bold)
            .multilineTextAlignment(.center)
    }

    var release: some View {
        HStack {
            InformationDescription(
                title: "Release Date", description: presenter.game.released)
            Spacer()
        }
        .padding(.horizontal, 16)
    }

    var platformAndRating: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Platform")
                    .customFont(.caption, .bold)
                Spacer()
                Text("Rating")
                    .customFont(.caption, .bold)
            }
            HStack {
                HStack {
                    PlatformIcons(
                        platforms: presenter.game.platforms.map { $0.slug })
                    Spacer()
                    RatingView(presenter.game.rating)
                }
            }
        }
        .padding(.horizontal, 16)
    }

    var content: some View {
        if let gameDetail = presenter.gameDetail {
            AnyView(
                VStack(spacing: 20) {
                    VStack(alignment: .center, spacing: 0) {
                        title

                        if gameDetail.developers.count > 0 {
                            Text(
                                "\(mapMultipleStringWithComa(gameDetail.developers.map { $0.name }))"
                            )
                            .customFont(.title3)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)

                    platformAndRating

                    if let age = gameDetail.esrbRating?.name, !age.isEmpty {
                        HStack(spacing: 10) {
                            Text("Age Rating:")
                                .customFont(.caption, .bold)
                            Tag("\(age)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Genre:")
                            .customFont(.caption, .bold)
                            .padding(.horizontal, 16)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(gameDetail.genres) { genre in
                                    Tag("\(genre.name)")
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 1)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Text("\(gameDetail.descriptionRaw)")
                        .lineLimit(isShowingFullDescription ? .max : 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .customFont(.body)
                        .padding(.horizontal, 16)
                        .onTapGesture {
                            isShowingFullDescription.toggle()
                        }

                    if !presenter.screenshots.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Screenshots")
                                .customFont(.headline)
                                .padding(.horizontal, 16)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(presenter.screenshots) { screenshot in
                                        VStack {
                                            CachedAsyncImage(url: URL(string: "\(screenshot.image)")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                            } placeholder: {
                                                ProgressView()
                                            }
                                        }
                                        .frame(width: 225, height: 125, alignment: .center)
                                        .background(Color.regularGray)
                                        .cornerRadius(16)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Information")
                            .customFont(.headline)
                        if let url: URL = URL(string: "\(gameDetail.website)") {
                            HStack {
                                Text("Website")
                                    .customFont(.subheadline, .bold)
                                Spacer()
                                Image(systemName: "safari")
                            }
                            .onTapGesture {
                                openURL(url)
                            }
                        }
                        InformationDescription(
                            title: "Platform",
                            description: "\(mapMultipleStringWithComa(presenter.game.platforms.map { $0.name }))"
                        )
                        InformationDescription(
                            title: "Genre",
                            description: "\(mapMultipleStringWithComa(gameDetail.genres.map { $0.name }))"
                        )
                        InformationDescription(
                            title: "Release Date",
                            description: "\(presenter.game.released)"
                        )
                        InformationDescription(
                            title: "Publisher",
                            description: "\(mapMultipleStringWithComa(gameDetail.publishers.map { $0.name }))"
                        )

                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)

                }
            )
        } else {
            AnyView(
                EmptyView()
            )
        }
    }
}

extension DetailView {

    func mapMultipleStringWithComa(_ stringsParams: [String]) -> String {
        var strings: [String] = stringsParams

        if strings.isEmpty {
            return ""
        }

        if strings.count <= 1 {
            return strings[0]
        } else {
            let lastStr: String = strings.removeLast()
            var stringResult: String = strings.removeFirst()

            for str in strings {
                stringResult += ", \(str)"
            }

            stringResult += ", and \(lastStr)"

            return stringResult
        }
    }

    func openURL(_ url: URL) {
        UIApplication.shared.open(url)
    }

}

#Preview {
    let detailUseCase: DetailUseCase = Injection.init(true).provideDetail(
        game: exampleGameModel)
    let detailPresenter: DetailPresenter = DetailPresenter(
        detailUseCase: detailUseCase)
    DetailView(presenter: detailPresenter)
}
