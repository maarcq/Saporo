//
//  IngredientSearchView.swift
//  ipadOS
//
//  Created by Raynara Coelho on 13/06/25.
//

//import SwiftUI
//
//struct IngredientSearchView: View {
//    @StateObject private var viewModel = IngredientSearchViewModel() // Um único ViewModel para tudo
//
//    var body: some View {
//        NavigationStack {
//            HStack{
//                TextField("Buscar ingredientes (ex: leite)", text: $viewModel.searchText)
//                    .textFieldStyle(.roundedBorder)
//                    .autocorrectionDisabled() // Geralmente bom para busca
//                    .textInputAutocapitalization(.never) // Geralmente bom para busca
//                    .padding(.leading) // Ajuste de padding para o TextField
//                    .padding(.trailing, 8)
//                    .onSubmit {
//                        Task {
//                            await viewModel.searchIngredients()
//                        }
//                    }
//
//                // Botão para limpar a busca (se houver texto)
//                if !viewModel.searchText.isEmpty {
//                    Button(action: {
//                        viewModel.searchText = ""
//                        viewModel.searchResults = [] // Limpa resultados ao cancelar
//                    }) {
//                        Image(systemName: "xmark.circle.fill")
//                            .foregroundColor(.gray)
//                    }
//                    .padding(.trailing, 8)
//                }
//            }
//            VStack {
//                // MARK: - Status Indicators (Loading, Error)
//                if viewModel.isLoading {
//                    ProgressView("Buscando ingredientes...")
//                        .padding()
//                } else if let errorMessage = viewModel.errorMessage {
//                    Text("Erro: \(errorMessage)")
//                        .foregroundColor(.red)
//                        .padding()
//                }
//
//                // MARK: - Search Results (visible only if there's search text and results)
//                if !viewModel.searchText.isEmpty { // Only show search results if search text is not empty
//                    if !viewModel.searchResults.isEmpty {
//                        Text("Resultados da Busca")
//                            .font(.headline)
//                            .padding(.horizontal)
//                            .frame(maxWidth: .infinity, alignment: .leading) // Align left
//
//                        List {
//                            ForEach(viewModel.searchResults) { ingredient in
//                                HStack {
//                                    // Image
//                                    if let imageUrl = ingredient.image,
//                                       let url = URL(string: "https://spoonacular.com/cdn/ingredients_100x100/\(imageUrl)") {
//                                        AsyncImage(url: url) { image in
//                                            image.resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(width: 40, height: 40)
//                                                .cornerRadius(5)
//                                        } placeholder: {
//                                            ProgressView()
//                                                .frame(width: 40, height: 40)
//                                        }
//                                    } else {
//                                        Image(systemName: "photo")
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(width: 40, height: 40)
//                                            .cornerRadius(5)
//                                            .foregroundColor(.gray)
//                                    }
//
//                                    Text(ingredient.name)
//                                        .font(.subheadline)
//
//                                    // Quantity Buttons to ADD to pantry
//                                    HStack {
//                                        Button {
//                                            viewModel.updatePantryItemQuantity(
//                                                ingredientID: ingredient.id,
//                                                name: ingredient.name,
//                                                image: ingredient.image,
//                                                change: -1.0
//                                            )
//                                        } label: {
//                                            Image(systemName: "minus.circle.fill")
//                                                .foregroundColor(.red)
//                                        }
//                                        .buttonStyle(.plain)
//
//                                        // Display CURRENT quantity in pantry (or 0 if not there)
//                                        Text(String(format: "%.0f", viewModel.userPantry.first(where: { $0.id == ingredient.id })?.quantity ?? 0.0))
//                                            .frame(minWidth: 20)
//                                            .font(.caption)
//
//                                        Button {
//                                            viewModel.updatePantryItemQuantity(
//                                                ingredientID: ingredient.id,
//                                                name: ingredient.name,
//                                                image: ingredient.image,
//                                                change: 1.0
//                                            )
//                                        } label: {
//                                            Image(systemName: "plus.circle.fill")
//                                                .foregroundColor(.green)
//                                        }
//                                        .buttonStyle(.plain)
//                                    }
//                                    .padding(.horizontal, 6)
//                                    .background(Capsule().fill(Color.gray.opacity(0.1)))
//                                    .cornerRadius(12)
//                                }
//                                .padding(.vertical, 2)
//                            }
//                        }
//                        //.frame(height: 200) // Limits the height of the results list
//                    } else {
//                        // Optional: Message when search text is present but no results found
//                        if viewModel.searchPerformed { // Se a busca já foi executada (Enter pressionado)
//                            Text("Nenhum resultado encontrado para '\(viewModel.searchText)'")
//                                .foregroundColor(.gray)
//                                .padding()
//                        } else { // Se a busca ainda não foi executada (apenas digitando)
//                            Text("Aperte enter para encontrar resultados para '\(viewModel.searchText)'")
//                                .foregroundColor(.gray)
//                                .padding()
//                        }
//                        Spacer()
//                    }
//                } else { // Show pantry if search text is empty
//                    if viewModel.userPantry.isEmpty {
//                        Spacer() // To push the message to the center if the list is empty
//                        Text("Sua despensa está vazia. Adicione alguns ingredientes pela busca acima!")
//                            .foregroundColor(.gray)
//                            .multilineTextAlignment(.center)
//                            .padding()
//                        Spacer()
//                    } else {
//                        List {
//                            ForEach($viewModel.userPantry) { $pantryItem in // Use $ for editable binding
//                                HStack {
//                                    // Image
//                                    if let imageUrl = pantryItem.image,
//                                       let url = URL(string: "https://spoonacular.com/cdn/ingredients_100x100/\(imageUrl)") {
//                                        AsyncImage(url: url) { image in
//                                            image.resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(width: 50, height: 50)
//                                                .cornerRadius(8)
//                                        } placeholder: {
//                                            ProgressView()
//                                                .frame(width: 50, height: 50)
//                                        }
//                                    } else {
//                                        Image(systemName: "photo")
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(width: 50, height: 50)
//                                            .cornerRadius(8)
//                                            .foregroundColor(.gray)
//                                    }
//
//                                    Text(pantryItem.name)
//                                        .font(.headline)
//                                    Spacer()
//
//                                    // Quantity Buttons for the pantry
//                                    HStack {
//                                        Button {
//                                            viewModel.updatePantryItemQuantity(
//                                                ingredientID: pantryItem.id,
//                                                name: pantryItem.name,
//                                                image: pantryItem.image,
//                                                change: -1.0
//                                            )
//                                        } label: {
//                                            Image(systemName: "minus.circle.fill")
//                                                .foregroundColor(.red)
//                                        }
//                                        .buttonStyle(.plain)
//
//                                        // Display the item quantity in the pantry
//                                        Text(String(format: "%.0f", pantryItem.quantity))
//                                            .frame(minWidth: 30)
//                                            .font(.subheadline)
//
//                                        Button {
//                                            viewModel.updatePantryItemQuantity(
//                                                ingredientID: pantryItem.id,
//                                                name: pantryItem.name,
//                                                image: pantryItem.image,
//                                                change: 1.0
//                                            )
//                                        } label: {
//                                            Image(systemName: "plus.circle.fill")
//                                                .foregroundColor(.green)
//                                        }
//                                        .buttonStyle(.plain)
//                                    }
//                                    .padding(.horizontal, 8)
//                                    .background(Capsule().fill(Color.gray.opacity(0.1)))
//                                    .cornerRadius(15)
//                                }
//                                .padding(.vertical, 4)
//                            }
//                            .onDelete(perform: viewModel.removePantryItem) // Allow swipe to remove
//                        }
//                        // The pantry list takes the remaining space
//                    }
//                }
//            }
//        }
//        .navigationTitle("Minha Despensa") // Título da barra de navegação
//    }
//}
