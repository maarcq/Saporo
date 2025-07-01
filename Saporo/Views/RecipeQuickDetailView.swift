//
//  RecipeQuickDetailView.swift
//  Saporo
//
//  Created by Bernardo Santos Maranhão Maia on 30/06/25.
//

import SwiftUI

struct RecipeQuickDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: RecipeDetailViewModel
    @Binding var navigationPath: NavigationPath

    init(recipeId: Int, navigationPath: Binding<NavigationPath>) {
        _viewModel = StateObject(wrappedValue: RecipeDetailViewModel(recipeId: recipeId))
        _navigationPath = navigationPath
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Carregando receita...")
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Erro: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if let recipe = viewModel.recipe {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(alignment: .top, spacing: 20) {
                                if let imageUrl = recipe.image, let url = URL(string: imageUrl) {
                                    AsyncImage(url: url) { imagePhase in
                                        switch imagePhase {
                                        case .empty:
                                            ProgressView()
                                                .frame(width: 150, height: 150)
                                        case .success(let image):
                                            image.resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 200, height: 200)
                                                .cornerRadius(16)
                                                .shadow(radius: 5)
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 200, height: 200)
                                                .cornerRadius(16)
                                                .foregroundColor(.gray)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 200, height: 200)
                                        .cornerRadius(16)
                                        .foregroundColor(.gray)
                                }

                                VStack(alignment: .leading, spacing: 10) {
                                    Text(recipe.title)
                                        .font(.poppinsBold(size: 32))
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.7)
                                        .padding(.bottom, 5)

                                    HStack(spacing: 20) {
                                        if let readyInMinutes = recipe.readyInMinutes {
                                            HStack {
                                                Image(systemName: "hourglass")
                                                Text("\(readyInMinutes) min")
                                            }
                                        }
                                        HStack {
                                            Image(systemName: "globe")
                                            Text("Italiana")
                                        }
                                    }
                                    .font(.poppinsMedium(size: 18))

                                    HStack(spacing: 20) {
                                        if let servings = recipe.servings {
                                            HStack {
                                                Image(systemName: "person.2")
                                                Text("\(servings) porções")
                                            }
                                        }
                                        HStack {
                                            Image(systemName: "flame")
                                            Text("300 calorias")
                                        }
                                    }
                                    .font(.poppinsMedium(size: 18))
                                }
                                .padding(.top, 10)
                            }
                            .padding(.horizontal)

                            Text("Ingredientes")
                                .font(.poppinsBold(size: 28))
                                .padding(.horizontal)
                                .padding(.top, 10)

                            VStack(alignment: .leading, spacing: 8) {
                                if let ingredients = recipe.extendedIngredients, !ingredients.isEmpty {
                                    ForEach(ingredients, id: \.uuid) { ingredient in
                                        Text("\(ingredient.name.capitalized) \(String(format: "%.0f", ingredient.amount)) \(ingredient.unit)")
                                            .font(.poppinsRegular(size: 20))
                                    }
                                } else {
                                    Text("Nenhum ingrediente listado.")
                                        .font(.poppinsRegular(size: 20))
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(.systemGray6))
                            )
                            .padding(.horizontal)
                            .padding(.top, 5)

                            Spacer()
                        }
                    }
                    
                    Button {
                        if let analyzedInstructions = recipe.analyzedInstructions, !analyzedInstructions.isEmpty {
                            dismiss()
                            navigationPath.append(analyzedInstructions)
                        } else {
                            viewModel.errorMessage = "Instruções não disponíveis para esta receita."
                        }
                    } label: {
                        Text("Preparar")
                            .font(.poppinsBold(size: 24))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color("ColorCircleInstructions"))
                            .cornerRadius(15)
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                    }
                    .disabled(recipe.analyzedInstructions?.isEmpty ?? true)
                } else {
                    Text("Receita não encontrada ou erro de carregamento.")
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Voltar")
                        }
                        .foregroundStyle(Color("LabelsColor"))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.toggleFavorite()
                    } label: {
                        Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                            .foregroundColor(viewModel.isFavorite ? .yellow : Color("LabelsColor"))
                    }
                }
            }
            .background {
                BackgroundGeral()
            }
            .task {
                await viewModel.loadRecipeDetails()
            }
        }
    }
}

#Preview {
    RecipeQuickDetailView(recipeId: 716429, navigationPath: .constant(NavigationPath()))
}
