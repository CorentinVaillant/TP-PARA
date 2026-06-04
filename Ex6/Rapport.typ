#let doc_name = [Rapport exercice VI]

#set document(
  title: doc_name,
)
#set text(lang: "fr")
#set page(paper: "a4")
#set heading(numbering: "I.1.a")
#set page(header: [Parallélisme #h(1fr) #doc_name])
#set page(footer: context [
  _Corentin Vaillant_
  #h(1fr)
  #counter(page).display(
    "1/1",
    both: true,
  )
])
#show link: set text(weight: 700)
#show link: underline

#let data = json("./results.json")
#let github = link("https://github.com/CorentinVaillant/TP-PARA/tree/main/Ex2")[*GitHub*]


#title()

= Présentation de l’exercice

Le but de l'exercice était de récupérer une implantation déjà faite de l'algorithme Dijkstra, et de chercher à l'optimiser en parallélisant le programme.\ J'ai fait le choix de réécrire l'implantation en `C++`, car je voulais expérimenter l'utilisation d'`OpenMp` en `C++`, je ne pense pas que cela change de manière significative les temps enregistrés, je n'ai pas utilisé de fonctionnalités haut niveau de la librairie standard de `C++`, mis à part les vecteurs, qui sont alloués préalablement, ce qui permet d'avoir une allocation mémoire similaire à un simple `malloc` en `C`.

= Calcul du temps
Afin de calculer les temps d'exécution, je me suis aidé d'un script Python, et de la sortie standard du programme en `c`.\
Toutes les données sont donc automatiquement compilées dans un fichier `Json`.

// Pour une bonne cohérence au niveau des mesures, j'ai fait une moyenne sur *METTRE NOMBRE* exécutions pour chaque test.

= Résultats
Voici les résultats en fonction de chacune des images données en test, avec un nombre de threads allant de 1 à 16.

== Temps pour le graphe représentant Rome

Ce graphe contients 3353 nœuds et 8870 arrêtes, voici les temps obtenus deçus :

#let file = "test/rome.gr"
#columns(2)[
  #table(
    table.header([*Nombre de threads*], [*Temps pris*]),
    columns: 2,
    [1], $#{ int(data.at(file).at("1").time * 1 * 1e6) / 1e6 } s$,
    [2], $#{ int(data.at(file).at("2").time * 1 * 1e6) / 1e6 } s$,
    [3], $#{ int(data.at(file).at("3").time * 1 * 1e6) / 1e6 } s$,
    [4], $#{ int(data.at(file).at("4").time * 1 * 1e6) / 1e6 } s$,
    [5], $#{ int(data.at(file).at("5").time * 1 * 1e6) / 1e6 } s$,
    [6], $#{ int(data.at(file).at("6").time * 1 * 1e6) / 1e6 } s$,
    [7], $#{ int(data.at(file).at("7").time * 1 * 1e6) / 1e6 } s$,
    [8], $#{ int(data.at(file).at("8").time * 1 * 1e6) / 1e6 } s$,
  )
  #colbreak()
  #table(
    table.header([*Nombre de thread*], [*Temps pris*]),
    columns: 2,
    [9], $#{ int(data.at(file).at("9").time * 1 * 1e6) / 1e6 } s$,
    [10], $#{ int(data.at(file).at("10").time * 1 * 1e6) / 1e6 } s$,
    [11], $#{ int(data.at(file).at("11").time * 1 * 1e6) / 1e6 } s$,
    [12], $#{ int(data.at(file).at("12").time * 1 * 1e6) / 1e6 } s$,
    [13], $#{ int(data.at(file).at("13").time * 1 * 1e6) / 1e6 } s$,
    [14], $#{ int(data.at(file).at("14").time * 1 * 1e6) / 1e6 } s$,
    [15], $#{ int(data.at(file).at("15").time * 1 * 1e6) / 1e6 } s$,
    [16], $#{ int(data.at(file).at("16").time * 1 * 1e6) / 1e6 } s$,
  )
]
#image("./images/rome_times.svg", width: 70%)


On peut observer une bonne évolution du temps, ce dernier semble baisser de moitié, la parallélisation est donc efficace.
Regardons cela plus concrètement avec un graphique représentant l'accélération :

#image("./images/rome_acc.svg", width: 70%)

L'accélération maximale est d'environ $2.3$, aux alentours de six threads.
Après six threads, le temps redevient croissant, cela doit être dû à la synchronisation entre les threads, en effet, l'implantation utilise un bon nombre de barrières de synchronisations.


== Temps pour le graphe représentant New York

Le deuxième graphe (New York) est de tailles conséquentes, $264346$ nœuds et $733846$ arrêtes, voici les résultats obtenus :

#let file = "test/new_york.gr"
#columns(2)[
  #table(
    table.header([*Nombre de thread*], [*Temps pris*]),
    columns: 2,
    [1], $#{ int(data.at(file).at("1").time * 1 * 1e6) / 1e6 } s$,
    [2], $#{ int(data.at(file).at("2").time * 1 * 1e6) / 1e6 } s$,
    [3], $#{ int(data.at(file).at("3").time * 1 * 1e6) / 1e6 } s$,
    [4], $#{ int(data.at(file).at("4").time * 1 * 1e6) / 1e6 } s$,
    [5], $#{ int(data.at(file).at("5").time * 1 * 1e6) / 1e6 } s$,
    [6], $#{ int(data.at(file).at("6").time * 1 * 1e6) / 1e6 } s$,
    [7], $#{ int(data.at(file).at("7").time * 1 * 1e6) / 1e6 } s$,
    [8], $#{ int(data.at(file).at("8").time * 1 * 1e6) / 1e6 } s$,
  )
  #colbreak()
  #table(
    table.header([*Nombre de thread*], [*Temps pris*]),
    columns: 2,
    [9], $#{ int(data.at(file).at("9").time * 1 * 1e6) / 1e6 } s$,
    [10], $#{ int(data.at(file).at("10").time * 1 * 1e6) / 1e6 } s$,
    [11], $#{ int(data.at(file).at("11").time * 1 * 1e6) / 1e6 } s$,
    [12], $#{ int(data.at(file).at("12").time * 1 * 1e6) / 1e6 } s$,
    [13], $#{ int(data.at(file).at("13").time * 1 * 1e6) / 1e6 } s$,
    [14], $#{ int(data.at(file).at("14").time * 1 * 1e6) / 1e6 } s$,
    [15], $#{ int(data.at(file).at("15").time * 1 * 1e6) / 1e6 } s$,
    [16], $#{ int(data.at(file).at("16").time * 1 * 1e6) / 1e6 } s$,
  )
]

#image("./images/ny_times.svg", width: 70%)

Les temps sont bien plus grands que le graphe précédent, on passe de l'ordre du centième de secondes, à centaine de secondes, mais l'évolution du temps semble bien plus efficace, observons l'accélération afin de confirmer :

#image("./images/ny_acc.svg", width: 70%)

En effet, on constate une nette accélération, allant jusqu'à $5 times$ plus vite que la version à $1$ thread.\
De plus, on voit bien ici une évolution ressemblant à celle théorisée par la loi d'Amdahl, l'accélération augmente de manière hyperbolique, puis parait se stabiliser.

= Conclusion

On remarque dans cet exercice que la parallélisation à bien plus d'effet sur de grands jeux de données, que sur des petits,
nous avons pu observer que, pour cette implantation, les barrières du programme ont un effet moins visible sur les grands jeux de données.\
Il semble donc bon de dire que cette parallélisation est bien utiles, en particuliers pour de grands jeux de données, mais il faudrait voir comment elle se comporterais sur une mise à l'échelle, où les graphes sont bien plus large qu'une seul ville (malgrés la taille de New York), probablement qu'il faudrait adopter une autre approche à cette "simple" parallélisation.

== Machine utilisée <machine>
Tous les temps ont été enregistrés sur un ordinateur portable avec un processeur `x86-64` de huit cœurs physiques dont deux virtuels par cœur, cadencé à \~3.5 GHz (sur secteur).

== Données récoltées
Toutes les mesures effectuées sont stockées dans un document _json_  récupérer grâce à la sortie standard du programme, et à un script Python, trouvable sur le #github.

== Code <source-code>

L’entièreté du code se trouve sur le #github dans le fichier `Ex6`.

== Notice sur l'utilisation de l'IA générative
L'IA générative n'a pas été utilisée pour cet exercice.


