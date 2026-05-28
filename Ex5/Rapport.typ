#let doc_name = [Rapport exercice V]

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

Le but de l'exercice était d'implémenter un algorithme qui augmente le contraste d'une image en niveaux de gris, et ensuite de le paralléliser.

= Calcul du temps
Afin de calculer les temps d'exécution, je me suis aidé d'un script Python, et de la sortie standard du programme en `c`.\
Toutes les données sont donc automatiquement compilées dans un fichier `Json`.

Pour une bonne cohérence au niveau des mesures, j'ai fait une moyenne sur 100 exécutions pour chaque test.

= Résultats
Voici les résultats en fonction de chacune des images données en test, avec un nombre de threads allant de 1 à 16.

== Temps pour la première image

#columns(2)[
  #table(
    table.header([*Nombre de thread*], [*Temps pris*]),
    columns: 2,
    [1], $#{ int(data.at("image0.ppm").at("1").time * 1000 * 1e6) / 1e6 } m\s$,
    [2], $#{ int(data.at("image0.ppm").at("2").time * 1000 * 1e6) / 1e6 } m\s$,
    [3], $#{ int(data.at("image0.ppm").at("3").time * 1000 * 1e6) / 1e6 } m\s$,
    [4], $#{ int(data.at("image0.ppm").at("4").time * 1000 * 1e6) / 1e6 } m\s$,
    [5], $#{ int(data.at("image0.ppm").at("5").time * 1000 * 1e6) / 1e6 } m\s$,
    [6], $#{ int(data.at("image0.ppm").at("6").time * 1000 * 1e6) / 1e6 } m\s$,
    [7], $#{ int(data.at("image0.ppm").at("7").time * 1000 * 1e6) / 1e6 } m\s$,
    [8], $#{ int(data.at("image0.ppm").at("8").time * 1000 * 1e6) / 1e6 } m\s$,
  )
  #colbreak()
  #table(
    table.header([*Nombre de thread*], [*Temps pris*]),
    columns: 2,
    [9], $#{ int(data.at("image0.ppm").at("9").time * 1000 * 1e6) / 1e6 } m\s$,
    [10], $#{ int(data.at("image0.ppm").at("10").time * 1000 * 1e6) / 1e6 } m\s$,
    [11], $#{ int(data.at("image0.ppm").at("11").time * 1000 * 1e6) / 1e6 } m\s$,
    [12], $#{ int(data.at("image0.ppm").at("12").time * 1000 * 1e6) / 1e6 } m\s$,
    [13], $#{ int(data.at("image0.ppm").at("13").time * 1000 * 1e6) / 1e6 } m\s$,
    [14], $#{ int(data.at("image0.ppm").at("14").time * 1000 * 1e6) / 1e6 } m\s$,
    [15], $#{ int(data.at("image0.ppm").at("15").time * 1000 * 1e6) / 1e6 } m\s$,
    [16], $#{ int(data.at("image0.ppm").at("16").time * 1000 * 1e6) / 1e6 } m\s$,
  )
]
#image("./images/im0_times.svg", width: 70%)

La forte augmentation du temps à la fin est certainement due à un problème de cohérence de cache.

Voici maintenant un graphique synthétisant l'accélération en fonction du nombre de threads :

#image("./images/im0_acc.svg", width: 70%)

L'accélération maximale est de $1.37$, pour 10 threads.

== Temps pour la seconde image

#columns(2)[
  #table(
    table.header([*Nombre de thread*], [*Temps pris*]),
    columns: 2,
    [1], $#{ int(data.at("image1.ppm").at("1").time * 1000 * 1e6) / 1e6 } m\s$,
    [2], $#{ int(data.at("image1.ppm").at("2").time * 1000 * 1e6) / 1e6 } m\s$,
    [3], $#{ int(data.at("image1.ppm").at("3").time * 1000 * 1e6) / 1e6 } m\s$,
    [4], $#{ int(data.at("image1.ppm").at("4").time * 1000 * 1e6) / 1e6 } m\s$,
    [5], $#{ int(data.at("image1.ppm").at("5").time * 1000 * 1e6) / 1e6 } m\s$,
    [6], $#{ int(data.at("image1.ppm").at("6").time * 1000 * 1e6) / 1e6 } m\s$,
    [7], $#{ int(data.at("image1.ppm").at("7").time * 1000 * 1e6) / 1e6 } m\s$,
    [8], $#{ int(data.at("image1.ppm").at("8").time * 1000 * 1e6) / 1e6 } m\s$,
  )
  #colbreak()
  #table(
    table.header([*Nombre de thread*], [*Temps pris*]),
    columns: 2,
    [9], $#{ int(data.at("image1.ppm").at("9").time * 1000 * 1e6) / 1e6 } m\s$,
    [10], $#{ int(data.at("image1.ppm").at("10").time * 1000 * 1e6) / 1e6 } m\s$,
    [11], $#{ int(data.at("image1.ppm").at("11").time * 1000 * 1e6) / 1e6 } m\s$,
    [12], $#{ int(data.at("image1.ppm").at("12").time * 1000 * 1e6) / 1e6 } m\s$,
    [13], $#{ int(data.at("image1.ppm").at("13").time * 1000 * 1e6) / 1e6 } m\s$,
    [14], $#{ int(data.at("image1.ppm").at("14").time * 1000 * 1e6) / 1e6 } m\s$,
    [15], $#{ int(data.at("image1.ppm").at("15").time * 1000 * 1e6) / 1e6 } m\s$,
    [16], $#{ int(data.at("image1.ppm").at("16").time * 1000 * 1e6) / 1e6 } m\s$,
  )
]
#image("./images/im1_times.svg", width: 70%)

Encore une fois, on observe une forte augmentation du temps pour 16 threads, sans doute pour les mêmes raison.

Voici maintenant un graphique synthétisant l'accélération en fonction du nombre de threads :

#image("./images/im1_acc.svg", width: 70%)

L'accélération maximale est de $1.06$, pour 9 threads.
\
\
\
\
\
\

== Temps pour la troisième image

#columns(2)[
  #table(
    table.header([*Nombre de thread*], [*Temps pris*]),
    columns: 2,
    [1], $#{ int(data.at("image2.ppm").at("1").time * 1000 * 1e6) / 1e6 } m\s$,
    [2], $#{ int(data.at("image2.ppm").at("2").time * 1000 * 1e6) / 1e6 } m\s$,
    [3], $#{ int(data.at("image2.ppm").at("3").time * 1000 * 1e6) / 1e6 } m\s$,
    [4], $#{ int(data.at("image2.ppm").at("4").time * 1000 * 1e6) / 1e6 } m\s$,
    [5], $#{ int(data.at("image2.ppm").at("5").time * 1000 * 1e6) / 1e6 } m\s$,
    [6], $#{ int(data.at("image2.ppm").at("6").time * 1000 * 1e6) / 1e6 } m\s$,
    [7], $#{ int(data.at("image2.ppm").at("7").time * 1000 * 1e6) / 1e6 } m\s$,
    [8], $#{ int(data.at("image2.ppm").at("8").time * 1000 * 1e6) / 1e6 } m\s$,
  )
  #colbreak()
  #table(
    table.header([*Nombre de thread*], [*Temps pris*]),
    columns: 2,
    [9], $#{ int(data.at("image2.ppm").at("9").time * 1000 * 1e6) / 1e6 } m\s$,
    [10], $#{ int(data.at("image2.ppm").at("10").time * 1000 * 1e6) / 1e6 } m\s$,
    [11], $#{ int(data.at("image2.ppm").at("11").time * 1000 * 1e6) / 1e6 } m\s$,
    [12], $#{ int(data.at("image2.ppm").at("12").time * 1000 * 1e6) / 1e6 } m\s$,
    [13], $#{ int(data.at("image2.ppm").at("13").time * 1000 * 1e6) / 1e6 } m\s$,
    [14], $#{ int(data.at("image2.ppm").at("14").time * 1000 * 1e6) / 1e6 } m\s$,
    [15], $#{ int(data.at("image2.ppm").at("15").time * 1000 * 1e6) / 1e6 } m\s$,
    [16], $#{ int(data.at("image2.ppm").at("16").time * 1000 * 1e6) / 1e6 } m\s$,
  )
]
#image("./images/im2_times.svg", width: 70%)

Pour cette image, nous n'observons pas d'augmentation significative. \
Les données étant assez grandes, les problèmes de cohérence de cache sont alors évités.

#image("./images/im2_acc.svg", width: 70%)

L'accélération maximale est de $1.13$, pour 2 threads.\
Globalement, l'accélération semble rester stable, et surtout supérieure à 1.

= Conclusion
Pour conclure, le programme peut être peut-être accéléré grâce à la parallélisation, mais, pour pouvoir observer une accélération, il faut des données d'entrée assez grandes, car de trop petites données d'entrée produisent systématiquement des problèmes de cohérence de cache, ce qui ralentit fortement le programme.\
De plus la programmation sur `CPU` ne nous permet pas d'obtenir d'accélération spectaculaire pour de grandes images, pour cela il faudrait porter le programme sur `GPU`, afin d'avoir une parallélisation bien plus efficace, bien que l'effort de programmation soit bien plus important.

== Machine utilisé <machine>
Tous les temps ont été enregistrés sur un ordinateur portable avec un processeur `x86-64` de huit cœurs physiques dont deux virtuels par cœur, cadencé à \~3.5GHz (sur secteur).

== Données récolter
Toutes les mesures effectuées sont stockées dans un document _json_  récupérer grâce à la sortie standard du programme, et à un script Python, trouvable sur le #github.

== Code <source-code>

L’entièreté du code se trouve sur le #github dans le fichier `Ex5`.


== Notice sur l'utilisation de l'IA générative
L'IA générative n'a pas été utilisée pour cet exercice.

