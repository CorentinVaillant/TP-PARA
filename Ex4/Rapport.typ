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
#let github = link("https://github.com/CorentinVaillant/TP-PARA/tree/main/Ex2")[*GitHub*]
#let lien_expl1 = link("https://moodle.utoulouse.fr/pluginfile.php/123043/mod_folder/content/0/SacADos-part1.mp4")[ici]
#let lien_expl2 = link("https://moodle.utoulouse.fr/pluginfile.php/123043/mod_folder/content/0/SacADos-part2.mp4")[ici]

#title[
  #doc_name
]

= Présentation de l’exercice
Le but de l'exercice était d'implémenter une solution au problème du sac à dos, pour cela j'ai implémenteé un algorithme détailler #lien_expl1 et #lien_expl2.\
De plus, il nous était demandé de paralléliser le programme à l'aide d'`OpenMp`.\
L'implémentation est trouvable sur #github dans le fichier `Ex4`.

= Calcule du temps
Afin d'éviter les incohérence dû à la mise en cache, j'ai créer un script python [@source-code] qui exécuté le programme avec des arguments d’exécutions différents à chaque fois.\
Et de plus pour plus de stabilité, je calcule la moyenne des temps sur 200 executions.

= Résultats
TODO

== Quelques graphes de comparaison

Toutes les mesures on était synthétiser dans un document `Json`, en voici des comparaison graphiques.

=== Temps en fonction du nombre d'élément pour chacune des approche :
TODO

== Temps en fonction du nombre d'élément :
TODO

= Annexe <annexe>

== Machine utilisé <machine>
Tous les temps ont était enregistrer sur un ordinateur portable avec un processeur `x86-64` de huit cœurs physique dont deux virtuel par cœurs, cadencé à \~3.5GHz (sur secteur).

== Données récolter
Toutes les mesures effectuer son stocké dans un document _json_ récupérer grâce à la sortie standard du programme, et a un script python, trouvable sur le #github.

== Code <source-code>

L’entièreté du code se trouve sur le #github dans le fichier `Ex4`.
