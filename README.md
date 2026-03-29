
- introduire une barre de filtre et de tri : par durée, par note


1. La Recherche Simple (MVP - Minimum Viable Product)
C'est ta "base" avec la barre de recherche.

En tant qu' utilisateur pressé,
Je veux saisir le nom d'un ingrédient (ex: "poulet") dans une barre de recherche,
Afin de voir instantanément toutes les recettes qui contiennent cet ingrédient.


2. La Recherche Multicritères (Le "Frigo")
C'est ton idée de Combobox / Multiselect. C'est la "Killer Feature" d'une application de recettes.

En tant qu' utilisateur qui veut cuisiner avec ses restes,
Je veux sélectionner plusieurs ingrédients que j'ai déjà chez moi (ex: "tomate", "mozzarella", "basilic"),
Afin de trouver les recettes qui utilisent au moins tous ces éléments.

Challenge technique : Gérer un tableau d'IDs d'ingrédients en paramètre et filtrer les recettes qui possèdent l'intersection de ces ingrédients.

3. Le Filtrage par Temps ou Catégorie (Dropdown)
Tu en parlais avec le dropdown.

En tant qu' utilisateur affamé,
Je veux filtrer les résultats par temps de préparation (ex: moins de 30 min) ou par catégorie (ex: "Dessert"),
Afin de ne pas perdre de temps avec des recettes trop longues ou inadaptées.

Challenge technique : Utiliser des Scopes Rails dans ton modèle Recipe pour chaîner les filtres (ex: Recipe.cheaper_than(30).in_category(cat_id)).

4. La Story "Bonus" : Le Match Parfait
C'est ce qui rend l'appli intelligente.

En tant qu' utilisateur,
Je veux voir en premier les recettes où il me manque le moins d'ingrédients,
Afin de savoir si je dois aller faire des courses ou si je peux cuisiner tout de suite.
