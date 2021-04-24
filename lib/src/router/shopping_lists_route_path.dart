class ShoppingListsRoutePath {

  final String listId;
  final bool showError;
  final bool showCatalog;

  ShoppingListsRoutePath.home():
        this.listId = null,
        this.showError = false,
        this.showCatalog = false;

  ShoppingListsRoutePath.homeWithSharedList(this.listId):
        this.showError = false,
        this.showCatalog = false;

  ShoppingListsRoutePath.catalog():
      this.listId = null,
      this.showError = false,
      this.showCatalog = true;

  ShoppingListsRoutePath.error():
      this.listId = null,
      this.showError = true,
      this.showCatalog = false;

  bool get isHome => (listId == null && !showCatalog && !showError);

  bool get isHomeWithSharedList => listId != null;

  bool get isCatalog => showCatalog;

  bool get isError => showError;

}