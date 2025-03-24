#import "@preview/note-me:0.3.0": *
#import "@preview/tablex:0.0.9": tablex, rowspanx, colspanx
#let insa-short(
  author : none,
  date : none,
  doc
) = {
  set text(lang: "pl")
  set page(
    "a4",
    margin: (top: 3cm, bottom: 2cm, left: 1em, right:1em),
    header: [
      #place(left, [#image("img/logo.png", height: 3cm) #text(smallcaps("   Projekt Grupowy, informatyka 2024/2025"), baseline: -4em)], dy: 2cm)
      #place(right + bottom)[
        #author\
        #if type(date) == datetime [
          #date.display("[day]/[month]/[year]")
        ] else [
          #date
        ]
      ]
    ],
    
  )
  doc
}
#show: doc => insa-short(
  author: [
		Ada Kołodziejczak, 193450
		#linebreak()
    Jakub Bronowski, 193208
    #linebreak()
		Igor Józefowicz, 193257
		#linebreak()
    Piotr Trybisz, 193557
  ],
  doc)

#v(15pt)
#align(center, text(size: 21pt, weight: "bold", smallcaps("Aplikacja webowa do tagowania zdjęć")))
#align(center, text(size: 12pt, weight: "bold", smallcaps("Skrócona instrukcja dla użytkownika końcowego")))
#v(5pt)

#set heading(numbering: "1.")
/*#show heading.where(level: 2): it => [
  #counter(heading).display()
  #text(weight: "medium", style: "italic", size: 13pt, it.body)
]*/
#label("Spis treści")
#outline(title: "Spis treści", indent:  n => 1em * n, depth: 3)
= Wstęp
W celu zebrania zbioru oznaczonych zdjęć laryngoskopowych, stworzyliśmy aplikację webową, która pozwala na przeglądanie zdjęć oraz ich oznaczanie. W niniejszym dokumencie przedstawiamy architekturę aplikacji, opisujemy jej funkcjonalności oraz sposób korzystania z niej.
= Architektura aplikacji
Aplikacja została zbudowana przy użyciu frameworka Django, ze względu na jego prostotę oraz dużą ilość dostępnych bibliotek ułatwiających pracę. Do przechowywania danych użytkowników i oznaczeń używana jest baza danych PostgreSQL, natomiast do przechowywania samych zdjęć używana jest chmura Cloudflare R2.
#figure(
	image("img/architecture.png", width: 80%),
	caption: "Schemat architektury aplikacji"
)
= Panel administracyjny
Aplikacja posiada panel administracyjny, który pozwala na zarządzanie użytkownikami, zdjęciami oraz oznaczeniami. Panel ten jest dostępny pod adresem `/admin` i wymaga zalogowania się za pomocą konta administratora.
#figure(
	image("img/logowanie.png", width: 40%),
	caption: "Logowanie do panelu administracyjnego"
)

Po zalogowaniu widocznych jest 6 sekcji:
#figure(
	image("img/admin_zalogowany.png", width: 40%),
	caption: "Sekcje panelu administracyjnego"
)

1. *Groups* - sekcja pozwalająca na zarządzanie grupami użytkowników (obecnie nie używana)
2. *Users* - sekcja pozwalająca na zarządzanie użytkownikami, ich hasłami oraz uprawnieniami
3. *Datasets* - sekcja pozwalająca na zarządzanie zbiorami zdjęć
4. *Images* - sekcja pozwalająca na zarządzanie pojedynczymi zdjęciami
5. *Tag assignments* - sekcja pozwalająca na zarządzanie i wgląd w oznaczenia zdjęć
6. *Tags* - sekcja pozwalająca na definiowanie dostępnych tagów

== Przesyłanie zbioru obrazów do oznaczenia
Aby utworzyć i przesłać zbiór danych (obrazów) do oznaczania, należy przejść do sekcji *Datasets* i kliknąć przycisk *Add dataset*.
#figure(
  image("img/add_datasets.png", width: 80%),
  caption: "Widok listy zbiorów danych"
)

Następnie należy podać:
1. Nazwę zbioru danych
2. Opis zbioru danych
3. Tagi dostępne dla zbioru danych
  - Tagi można dodawać i usuwać z poziomu sekcji *Tags* lub klikając zielony przycisk +.

Oraz przesłać (pojedynczo przyciskiem _Add another Image_ lub zbiorowo poprzez sekcję _Bulk upload_) obrazy do oznaczenia.

#figure(
  image("img/add_dataset_form.png", width: 80%),
  caption: "Widok listy zbiorów danych"
)

Pole *Doctor invite code* zawiera unikalny kod, pozwalający na dostęp do zbioru danych. Należy go przekazać lekarzowi, który ma oznaczyć zdjęcia.

Na koniec należy kliknąć przycisk *Save*. Zbiór danych zostanie dodany do listy zbiorów danych.

Nie jest wymagane ręczne tworzenie kont użytkowników. Lekarz, który otrzyma kod zaproszenia, może zarejestrować się samodzielnie, podając kod w formularzu rejestracyjnym.

= Panel użytkownika
== Rejestracja
#figure(image("img/join.png", width: 40%), caption: "Formularz rejestracji")
== Logowanie
#figure(image("img/sign_in.png", width: 40%), caption: "Formularz logowania")


