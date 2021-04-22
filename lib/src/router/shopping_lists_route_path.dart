class ShoppingListsRoutePath {

  final String listName;
  final bool showError;
  final bool showCatalog;

  ShoppingListsRoutePath.home():
        this.listName = null,
        this.showError = false,
        this.showCatalog = false;

  ShoppingListsRoutePath.homeWithSharedList(this.listName):
        this.showError = false,
        this.showCatalog = false;

  ShoppingListsRoutePath.catalog():
      this.listName = null,
      this.showError = false,
      this.showCatalog = true;

  ShoppingListsRoutePath.error():
      this.listName = null,
      this.showError = true,
      this.showCatalog = false;

  bool get isHome => (listName == null && !showCatalog && !showError);

  bool get isHomeWithSharedList => listName != null;

  bool get isCatalog => showCatalog;

  bool get isError => showError;

}