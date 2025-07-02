//
//  RecipeDetailView.swift
//  ipadOS
//
//  Created by Bernardo Santos Maranhão Maia on 12/06/25.
//

import SwiftUI

struct RecipeDetailView: View {
    
    @StateObject private var viewModel: RecipeDetailViewModel
    @Binding var navigationPath: NavigationPath
    
    init(recipeId: Int, navigationPath: Binding<NavigationPath>) {
        self._navigationPath = navigationPath
        _viewModel = StateObject(wrappedValue: RecipeDetailViewModel(recipeId: recipeId))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                if viewModel.isLoading {
                    ProgressView("Carregando receita...")
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Erro ao carregar receita: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if let recipe = viewModel.recipe {
                    HStack(alignment: .top, spacing: 15) {
                        if let imageUrl = recipe.image, let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                    .shadow(radius: 5)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(recipe.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .minimumScaleFactor(0.7)
                            
                            HStack {
                                if let readyInMinutes = recipe.readyInMinutes {
                                    Label("\(readyInMinutes) min", systemImage: "timer")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer().frame(width: 10)
                                
                                if let servings = recipe.servings {
                                    Label("\(servings) porções", systemImage: "person.2")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                    
                    if let summary = recipe.summary {
                        Text("Resumo")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text(viewModel.stripHTML(from: summary))
                            .font(.body)
                            .padding(.bottom)
                    }
                    
                    if let analyzedInstructions = recipe.analyzedInstructions, !analyzedInstructions.isEmpty {
                        //                        NavigationLink(value: analyzedInstructions) {
                        //                            Label("Ver Passo a Passo", systemImage: "checklist.checked")
                        //                                .font(.headline)
                        //                                .foregroundColor(.white)
                        //                                .padding()
                        //                                .frame(maxWidth: .infinity)
                        //                                .background(Color.accentColor)
                        //                                .cornerRadius(10)
                        //                        Button {
                        //                            navigationPath.append(Destination.preparoReceita)
                        //                        } label: {
                        //                            Image(systemName: "checklist.checked")
                        //                            Text("ir para o passo a passo")
                        //                                .font(.headline)
                        //                                .padding()
                        //                        }
                        //                            NavigationLink(destination: RecipeInstructionsView(analyzedInstructions: analyzedInstructions)) {
                        //                                HStack {
                        //                                    Image(systemName: "checklist.checked")
                        //                                    Text("ir para o passo a passo")
                        //                                        .font(.headline)
                        //                                        .padding()
                        //                                }
                        //                                .foregroundColor(.white)
                        //                                .frame(maxWidth: .infinity)
                        //                                .background(Color.accentColor)
                        //                                .cornerRadius(10)
                        //                            }
                        //                        }
                        //                        .padding(.vertical, 5)
                    } else {
                        Text("Instruções passo a passo não disponíveis.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.vertical, 5)
                    }
                    
                    if let sourceUrl = recipe.sourceUrl, let url = URL(string: sourceUrl) {
                        Link("Ver Receita Original", destination: url)
                            .font(.headline)
                            .padding(.top)
                    }
                    
                } else {
                    Text("Nenhuma receita carregada.")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .navigationTitle(viewModel.recipe?.title ?? "Detalhes da Receita")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.toggleFavorite()
                    } label: {
                        Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                            .foregroundColor(viewModel.isFavorite ? .yellow : .gray)
                    }
                }
            }
            //            .navigationDestination(for: [RecipeInformation.AnalyzedInstruction].self) { instructions in
            //                RecipeInstructionsView(analyzedInstructions: instructions)
            //            }
            
            .task {
                await viewModel.loadRecipeDetails()
            }
        }
    }
}

#Preview {
    NavigationView {
        RecipeDetailView(recipeId: 716429, navigationPath: .constant(NavigationPath()))
    }
}
