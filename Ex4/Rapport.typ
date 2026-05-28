#let doc_name = [Rapport exercice IV]

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
#let github = link(
  "https://github.com/CorentinVaillant/TP-PARA/tree/main/Ex2",
)[*GitHub*]
#let lien_expl1 = link(
  "https://moodle.utoulouse.fr/pluginfile.php/123043/mod_folder/content/0/SacADos-part1.mp4",
)[ici]
#let lien_expl2 = link(
  "https://moodle.utoulouse.fr/pluginfile.php/123043/mod_folder/content/0/SacADos-part2.mp4",
)[ici]

#title[
  #doc_name
]

= Présentation de l’exercice
Le but de l'exercice était d'implémenter une solution au problème du sac à dos. Pour cela, j'ai implémenté un algorithme détaillé #lien_expl1 et #lien_expl2.\
De plus, il nous était demandé de paralléliser le programme à l'aide d'`OpenMp`.\
L'implémentation est trouvable sur #github dans le fichier `Ex4`.

= Calcul du temps
Afin d'éviter les incohérences dues à la mise en cache, j'ai créé un script python [@source-code] qui exécute le programme avec des arguments d'exécution différents à chaque fois.\
Et de plus, pour plus de stabilité, je calcule la moyenne des temps sur 200 exécutions.

= Résultats
Selon les fichiers de test fournis, les résultats ne sont pas les même.

== pb1

Pour le premier fichier de test, on peut observer ces temps

*Temps pris par l'implémentation pour `pb1.pb`.*

#columns(2)[
  #table(
    table.header([*Nombre de thread*], [*Temps pris*]),
    columns: 2,
    [1], $#{ int(data.at("./pb/pb1.pb").at("1").time * 1000 * 1e6) / 1e6 } m\s$,
    [2], $#{ int(data.at("./pb/pb1.pb").at("2").time * 1000 * 1e6) / 1e6 } m\s$,
    [3], $#{ int(data.at("./pb/pb1.pb").at("3").time * 1000 * 1e6) / 1e6 } m\s$,
    [4], $#{ int(data.at("./pb/pb1.pb").at("4").time * 1000 * 1e6) / 1e6 } m\s$,
    [5], $#{ int(data.at("./pb/pb1.pb").at("5").time * 1000 * 1e6) / 1e6 } m\s$,
    [6], $#{ int(data.at("./pb/pb1.pb").at("6").time * 1000 * 1e6) / 1e6 } m\s$,
    [7], $#{ int(data.at("./pb/pb1.pb").at("7").time * 1000 * 1e6) / 1e6 } m\s$,
    [8], $#{ int(data.at("./pb/pb1.pb").at("8").time * 1000 * 1e6) / 1e6 } m\s$,
  )
  #colbreak()
  #table(
    table.header([*Nombre de thread*], [*Temps pris*]),
    columns: 2,
    [9], $#{ int(data.at("./pb/pb1.pb").at("9").time * 1000 * 1e6) / 1e6 } m\s$,
    [10], $#{ int(data.at("./pb/pb1.pb").at("10").time * 1000 * 1e6) / 1e6 } m\s$,
    [11], $#{ int(data.at("./pb/pb1.pb").at("11").time * 1000 * 1e6) / 1e6 } m\s$,
    [12], $#{ int(data.at("./pb/pb1.pb").at("12").time * 1000 * 1e6) / 1e6 } m\s$,
    [13], $#{ int(data.at("./pb/pb1.pb").at("13").time * 1000 * 1e6) / 1e6 } m\s$,
    [14], $#{ int(data.at("./pb/pb1.pb").at("14").time * 1000 * 1e6) / 1e6 } m\s$,
    [15], $#{ int(data.at("./pb/pb1.pb").at("15").time * 1000 * 1e6) / 1e6 } m\s$,
    [16], $#{ int(data.at("./pb/pb1.pb").at("16").time * 1000 * 1e6) / 1e6 } m\s$,
  )
]
#image("./images/pb1_times.svg", width: 70%)

Nous remarquons que le temps augmente en fonction du nombre de threads, `pb1` étant très petit (seulement 5 objets), le temps d'attente des threads écrase vite celui de l'exécution mono-thread.

== pb2

Ensuite, pour le second test, nous avons :

*Temps pris par l'implémentation pour `pb2.pb`.*

#columns(2)[
  #table(
    table.header([*Nombre de thread*], [*Temps pris*]),
    columns: 2,
    [1], $#{ int(data.at("./pb/pb2.pb").at("1").time * 1000 * 1e6) / 1e6 } m\s$,
    [2], $#{ int(data.at("./pb/pb2.pb").at("2").time * 1000 * 1e6) / 1e6 } m\s$,
    [3], $#{ int(data.at("./pb/pb2.pb").at("3").time * 1000 * 1e6) / 1e6 } m\s$,
    [4], $#{ int(data.at("./pb/pb2.pb").at("4").time * 1000 * 1e6) / 1e6 } m\s$,
    [5], $#{ int(data.at("./pb/pb2.pb").at("5").time * 1000 * 1e6) / 1e6 } m\s$,
    [6], $#{ int(data.at("./pb/pb2.pb").at("6").time * 1000 * 1e6) / 1e6 } m\s$,
    [7], $#{ int(data.at("./pb/pb2.pb").at("7").time * 1000 * 1e6) / 1e6 } m\s$,
    [8], $#{ int(data.at("./pb/pb2.pb").at("8").time * 1000 * 1e6) / 1e6 } m\s$,
  )
  #colbreak()
  #table(
    table.header([*Nombre de thread*], [*Temps pris*]),
    columns: 2,
    [9],  $#{ int(data.at("./pb/pb2.pb").at("9").time * 1000 * 1e6) / 1e6 } m\s$,
    [10], $#{ int(data.at("./pb/pb2.pb").at("10").time * 1000 * 1e6) / 1e6 } m\s$,
    [11], $#{ int(data.at("./pb/pb2.pb").at("11").time * 1000 * 1e6) / 1e6 } m\s$,
    [12], $#{ int(data.at("./pb/pb2.pb").at("12").time * 1000 * 1e6) / 1e6 } m\s$,
    [13], $#{ int(data.at("./pb/pb2.pb").at("13").time * 1000 * 1e6) / 1e6 } m\s$,
    [14], $#{ int(data.at("./pb/pb2.pb").at("14").time * 1000 * 1e6) / 1e6 } m\s$,
    [15], $#{ int(data.at("./pb/pb2.pb").at("15").time * 1000 * 1e6) / 1e6 } m\s$,
    [16], $#{ int(data.at("./pb/pb2.pb").at("16").time * 1000 * 1e6) / 1e6 } m\s$,
  )
]
#image("./images/pb2_times.svg", width: 70%)

Nous pouvons pour observer une amélioration du temps jusqu'à environ 8 threads, puis une augmentation du temps.
Ce dernier augmente de façon significative pour 16 thread.\
L'explosion de fin est probablement due à un problème de cohérence de cache, en effet, les threads doivent tous rentrer en concurrence pour la lecture/écriture dans les blocs de cache, ce qui explique cette nette augmentation.

== pb6

Et enfin pour `pb6` :

*Temps pris par l'implémentation pour `pb6.pb`.*

#columns(2)[
  #table(
    table.header([*Nombre de thread*], [*Temps pris*]),
    columns: 2,
    [1], $#{ int(data.at("./pb/pb6.pb").at("1").time * 1000 * 1e6) / 1e6 } m\s$,
    [2], $#{ int(data.at("./pb/pb6.pb").at("2").time * 1000 * 1e6) / 1e6 } m\s$,
    [3], $#{ int(data.at("./pb/pb6.pb").at("3").time * 1000 * 1e6) / 1e6 } m\s$,
    [4], $#{ int(data.at("./pb/pb6.pb").at("4").time * 1000 * 1e6) / 1e6 } m\s$,
    [5], $#{ int(data.at("./pb/pb6.pb").at("5").time * 1000 * 1e6) / 1e6 } m\s$,
    [6], $#{ int(data.at("./pb/pb6.pb").at("6").time * 1000 * 1e6) / 1e6 } m\s$,
    [7], $#{ int(data.at("./pb/pb6.pb").at("7").time * 1000 * 1e6) / 1e6 } m\s$,
    [8], $#{ int(data.at("./pb/pb6.pb").at("8").time * 1000 * 1e6) / 1e6 } m\s$,
  )
  #colbreak()
  #table(
    table.header([*Nombre de thread*], [*Temps pris*]),
    columns: 2,
    [9],  $#{ int(data.at("./pb/pb6.pb").at("9").time * 1000 * 1e6) / 1e6 } m\s$,
    [10], $#{ int(data.at("./pb/pb6.pb").at("10").time * 1000 * 1e6) / 1e6 } m\s$,
    [11], $#{ int(data.at("./pb/pb6.pb").at("11").time * 1000 * 1e6) / 1e6 } m\s$,
    [12], $#{ int(data.at("./pb/pb6.pb").at("12").time * 1000 * 1e6) / 1e6 } m\s$,
    [13], $#{ int(data.at("./pb/pb6.pb").at("13").time * 1000 * 1e6) / 1e6 } m\s$,
    [14], $#{ int(data.at("./pb/pb6.pb").at("14").time * 1000 * 1e6) / 1e6 } m\s$,
    [15], $#{ int(data.at("./pb/pb6.pb").at("15").time * 1000 * 1e6) / 1e6 } m\s$,
    [16], $#{ int(data.at("./pb/pb6.pb").at("16").time * 1000 * 1e6) / 1e6 } m\s$,
  )
]
#image("./images/pb6_times.svg", width: 70%)

Le nombre de threads améliore le temps d'exécution, et semble ne plus trop avoir d'impact entre 8 et 16 threads.
Nous ne sommes pas confrontés à un problème de cache similaire à celui de `pb2`, car ici, les données étant très larges, les threads n'entrent pas en concurrence pour la lecture/écriture dans les blocs de cache.

= Conclusion

Nous pouvons conclure notre analyse avec la loi d'Amdahl :
L'accélération $S_n$ peut être calculée à partir de :
$S_n := T_1/T_n = 1/(s + (1-s)/N)$\
Avec :\
$T_1 :=$ \"Temps d'exécution de l'algorithme en séquentiel.\"\
$T_n :=$ \"Temps d'exécution de l'algorithme pour n threads en parallèle\" et \
$s :=$ \"Temps d'exécution de la partie non parallélisable du programme.\"\
De plus $S_n  ->_(n->+oo)1/s$\

Pour `pb2` et `pb6` la loi d'Amdahl parais bien être respectée, avec une accélération qui semble se stabiliser vers la fin (mis à part les problèmes de caches, non pris en compte par la loi d'Amdahl).

= Annexe <annexe>

== Machine utilisé <machine>
Tous les temps ont été enregistrés sur un ordinateur portable avec un processeur `x86-64` de huit cœurs physiques dont deux virtuels par cœur, cadencé à ~3,5 GHz (sur secteur).

== Données récolter
Toutes les mesures effectuées sont stockées dans un document _json_ récupérer grâce à la sortie standard du programme, et à un script Python, trouvable sur le #github.

== Code <source-code>

L’entièreté du code se trouve sur le #github dans le fichier `Ex4`.

== Notice sur l'utilisation de l'IA générative
L'IA générative n'a pas été utilisée pour cet exercice.
