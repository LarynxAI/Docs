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
      #place(left, [#image("img_tagger_and_classificator/logo.png", height: 3cm) #text(smallcaps("   Projekt Grupowy, informatyka 2025/2026"), baseline: -4em)], dy: 2cm)
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
#align(center, text(size: 21pt, weight: "bold", smallcaps("MedCategorizer")))
#align(center, text(size: 12pt, weight: "bold", smallcaps("Aplikacja do gromadzenia, klasyfikacji i tagowania zdjęć laryngoskopowych pacjentów")))
#v(5pt)

#set heading(numbering: "1.")
/*#show heading.where(level: 2): it => [
  #counter(heading).display()
  #text(weight: "medium", style: "italic", size: 13pt, it.body)
]*/
#label("Spis treści")
#outline(title: "Spis treści", indent:  n => 1em * n, depth: 3)
= Wstęp
Aplikacja webowa MedCategorizer jest narzędziem bazującym na ramie uprzednio wydanej aplikacji MedTagger i stanowi jej rozszerzenie. MedCategorizer pozwala gromadzić zdjęcia laryngoskopowe pacjentów w ramach konta pacjenta a także je tagować (celem stworzenia bazy obrazów uczących klasyfikator) lub klasyfikować (na podstawie decyzji klasyfikatora). 

= Architektura aplikacji
Podobnie jak w przypadku MedTagger, aplikacja webowa MedCategorizer została zbudowana przy użyciu frameworka Django, ze względu na jego prostotę oraz dużą ilość dostępnych bibliotek ułatwiających pracę. Aplikacja składa się z kilku części: panelu administracyjnego całej aplikacji, podaplikacji MedTagger oraz kartoteki pacjentów. Do przechowywania danych użytkowników, danych z kartoteki pacjentów, wyników klasyfikacji i oznaczenia nowych obrazów używana jest baza danych PostgreSQL. Do przechowywania samych zdjęć używana jest chmura Cloudflare R2. Kolejnym elementem aplikacji jest klasyfikator, który zrealizowano tak, aby mógł on być osobnym mikroserwisem. Pozwala to na jego łatwą wymianę, wybór innego typu klasyfikatora lub zwiększenie jego wydajności poprzez dołączenie nowych instancji. Klasyfikator ma dostęp do chmury Cloudflare R2, z której pobiera zbiory uczące lub obrazy do analizy i sklasyfikowania. Komunikacja między podaplikacją kartoteki pacjentów a klasyfikatorem odbywa się za pomocą API REST. Klasyfikator przyjmuje adres w chmurze R2 obrazu do sklasyfikowania oraz nazwę modelu, który ma być użyty do klasyfikacji. Klasyfikator zwraca wynik klasyfikacji w formacie JSON, który to zapisuje je wraz z danymi z kartoteki pacjenta do bazy danych PostgreSQL.
#figure(
	image("img_tagger_and_classificator/architecture.png", width: 90%),
	caption: "Schemat architektury aplikacji"
)

#figure(
	image("img_tagger_and_classificator/database_schema.png", width: 90%),
	caption: "Schemat bazy danych"
)

= Panel administracyjny
Aplikacja posiada panel administracyjny, który pozwala na zarządzanie użytkownikami, zdjęciami, oznaczeniami oraz kartoteką pacjentów. Jest to wspólny panel administracyjny dla obydwóch podaplikacji. Panel ten jest dostępny pod adresem `/admin` i wymaga zalogowania się za pomocą konta administratora.
#figure(
	image("img_tagger_and_classificator/logowanie.png", width: 40%),
	caption: "Logowanie do panelu administracyjnego"
)

Po zalogowaniu widocznych jest [JB: ileśtam] sekcji:
#figure(
	image("img_tagger_and_classificator/admin_zalogowany.png", width: 40%),
	caption: "Sekcje panelu administracyjnego"
)

[JB: ileśtam sekcji]
1. *Groups* - sekcja pozwalająca na zarządzanie grupami użytkowników (obecnie nie używana)
2. *Users* - sekcja pozwalająca na zarządzanie użytkownikami, ich hasłami oraz uprawnieniami
3. *Datasets* - sekcja pozwalająca na zarządzanie zbiorami zdjęć
4. *Images* - sekcja pozwalająca na zarządzanie pojedynczymi zdjęciami
5. *Tag assignments* - sekcja pozwalająca na zarządzanie i wgląd w oznaczenia zdjęć
6. *Tags* - sekcja pozwalająca na definiowanie dostępnych tagów

== Przesyłanie zbioru obrazów do oznaczenia
Aby utworzyć i przesłać zbiór danych (obrazów) do oznaczania, należy przejść do sekcji *Datasets* i kliknąć przycisk *Add dataset*.
#figure(
  image("img_tagger_and_classificator/add_datasets.png", width: 80%),
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
#figure(image("img_tagger_and_classificator/join.png", width: 40%), caption: "Formularz rejestracji")
== Logowanie
#figure(image("img_tagger_and_classificator/sign_in.png", width: 40%), caption: "Formularz logowania") \
Model logowania się do aplikacji jest jeden, spójny dla wszystkich podaplikacji. \

== Oznaczanie zdjęć i historia oznaczeń
Niniejsze funkcjonalności są udsotępnione lekarzom i opisane w dokumentacji aplikacji MedTagger. 
[JB: czy okej?]


= Kartoteki pacjentów
== Dodawanie nowej kartoteki pacjenta
[JB: oczekuję na zrealizowana funkcjonalność]

== Notatki nt. badanego pacjenta
[JB: oczekuję na zrealizowana funkcjonalność]

== Żądanie sklasyfikowania obiektu
Lekarz [JB: czy na pewno] dodając zdjęcie do kartoteki pacjenta, może zlecić jego sklasyfikowanie przy użyciu wybranego klasyfikatora. Pod względem technicznym, wysyłane jest zapytanie HTTP zawierające nazwę klasyfikatora oraz adres URL zdjęcia do sklasyfikowania. W odpowiedzi zwracany jest wynik klasyfikacji w formacie JSON, który może zostać dalej obrobiony, po czym zostaje on przeniesiony do bazy danych.
[JB: tu obrazek]

= Klasyfikator
Mając na względzie wciąż niewielką ilość danych, w chwili obecnej klasyfikator może nie zwracać w pełni poprawnych klasyfikacji. Niemniej, podjęto dezycję o zaimplementowaniu ramy klasyfikatora, dzięki czemu podmiana modeli klasyfikatora jest możliwa a dalsze prace mogą być prowadzone bez przeszkód i przestojów z wykorzystaniem mock'owego klasyfikatora. \
Komunikacja z klasyfikatorem odbywa się za pomocą API REST. Klasyfikator przyjmuje adres w chmurze R2 obrazu do sklasyfikowania oraz nazwę modelu, który ma być użyty do klasyfikacji. Klasyfikator zwraca wynik klasyfikacji w formacie JSON i zapisuje go wraz z danymi z kartoteki pacjenta do bazy danych PostgreSQL. 
