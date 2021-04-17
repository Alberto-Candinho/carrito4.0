class ShoppingListsRoutePath {

  final String listName;
  final bool isNotValid;
  final bool showCatalog;

  ShoppingListsRoutePath.home():
        this.listName = null,
        this.isNotValid = false,
        this.showCatalog = false;

  ShoppingListsRoutePath.homeWithSharedList(this.listName):
        this.isNotValid = false,
        this.showCatalog = false;

  ShoppingListsRoutePath.catalog():
      this.listName = null,
      this.isNotValid = false,
      this.showCatalog = true;

  ShoppingListsRoutePath.error():
      this.listName = null,
      this.isNotValid = true,
      this.showCatalog = false;

  bool get isHome => listName == null;

  bool get isHomeWithSharedList => listName != null;

  bool get isCatalog => showCatalog;

}