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
      #place(left, [#image("img_tagger_and_classificator/logo.png", height: 3cm) #text(smallcaps("   Projekt Grupowy, informatyka 2024/2025"), baseline: -4em)], dy: 2cm)
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
Aplikacja webowa MedCategorizer jest narzędziem bazującym na ramie uprzednio wydanej aplikacji MedTagger i stanowi jej rozszerzenie. MedCategorizer pozwala gromadzić zdjęcia laryngoskopowe pacjentów w ramach konta pacjenta a także je tagować (celem stworzenia bazy obrazów uczących klasyfikator) lub klasyfikować (na podstawie decyzji klasyfikatora). Szczegóły dotyczące komponentów MedTagger znajdują się w dokumencie "Aplikacja webowa do tagowania zdjęć" napisanym wcześniej - te komponenty nie uległy zmianie.

= Architektura aplikacji
Podobnie jak w przypadku MedTagger, aplikacja webowa MedCategorizer została zbudowana przy użyciu frameworka Django, ze względu na jego prostotę oraz dużą ilość dostępnych bibliotek ułatwiających pracę. Aplikacja składa się z kilku części: panelu administracyjnego całej aplikacji, podaplikacji MedTagger oraz podaplikacji kartoteki pacjentów. Do przechowywania danych użytkowników, danych z kartoteki pacjentów, wyników klasyfikacji i oznaczeń nowych obrazów używana jest baza danych PostgreSQL. Do przechowywania samych zdjęć używana jest chmura Cloudflare R2. Kolejnym elementem aplikacji jest klasyfikator, który zrealizowano tak, aby mógł on być osobnym komponentem. Klasyfikator i kartoteka pacjentów z niego korzystająca są względem siebie niczym czarne skrzynki (black box). Pozwala to na łatwą wymianę, wybór innego typu klasyfikatora lub zwiększenie wydajności tego komponentu poprzez dołączenie nowych instancji. Klasyfikator ma dostęp do chmury Cloudflare R2, z której pobiera obrazy do analizy i sklasyfikowania. Komunikacja między podaplikacją kartoteki pacjentów a klasyfikatorem odbywa się za pomocą REST API. Klasyfikator przyjmuje adres w chmurze R2 obrazu do sklasyfikowania oraz nazwę modelu, który ma być użyty do klasyfikacji. Klasyfikator zwraca wynik klasyfikacji w postaci łańcucha znaków, który wraz z danymi z kartoteki pacjenta zapisuje się do bazy danych PostgreSQL oraz wyświetla w otwartej karcie pacjenta. \
Poniżej prezentujemy schematy: architektury, bazy danych oraz modele danych.
#figure(
	image("img_tagger_and_classificator/architecture.png", width: 90%),
	caption: "Schemat architektury aplikacji"
)

#figure(
	image("img_tagger_and_classificator/database_schema.png", width: 90%),
	caption: "Schemat bazy danych"
)

#figure(
	image("img_tagger_and_classificator/model_pacjent.png", width: 90%),
	caption: "Model danych - pacjent"
)

#figure(
	image("img_tagger_and_classificator/model_rekord.png", width: 90%),
	caption: "Model danych - rekord"
)

#figure(
	image("img_tagger_and_classificator/model_klasyfikator.png", width: 90%),
	caption: "Model danych - klasyfikator"
)

= Komponenty, których funkcjonalności nie uległy znaczącej zmianie
1. Sposób przesyłania zbioru obrazów do oznaczenia.
2. Moduł oznaczania zdjęć (tu tylko wporwadzono możliwość eksportu tagów zdjęcia).
3. Historia oznaczeń.

= Komponenty nowe lub zmienione
== Rejestracja użytkowników
Zmiana objęła sposób rejestracji użytkowników. Nie trzeba podawać kodu zapraszającego do dołączenia do datasetu zdjęć. Dołączanie do datasetu przeniesiono do podaplikacji ImageTagger.
#figure(
	image("img_tagger_and_classificator/tworzenie_konta.png", width: 40%),
	caption: "Nowy formularz rejestacji do panelu administracyjnego"
)

== Panel administracyjny
Aplikacja posiada panel administracyjny, który pozwala na zarządzanie użytkownikami, zdjęciami, oznaczeniami oraz kartoteką pacjentów. Jest to wspólny panel administracyjny dla obydwóch podaplikacji. Panel ten jest dostępny pod adresem `/admin` i wymaga zalogowania się za pomocą konta administratora.
#figure(
	image("img_tagger_and_classificator/logowanie.png", width: 40%),
	caption: "Logowanie do panelu administracyjnego"
)

Po zalogowaniu widoczne są 3 główne sekcje: ImageTragger, Patient_records oraz Uwierzytelnienie i autoryzacja. Każda z głównych sekcji składa się z kilku sekcji opisanych poniżej.
#figure(
	image("img_tagger_and_classificator/admin_zalogowany.png", width: 60%),
	caption: "Sekcje panelu administracyjnego"
)

1. *Datasets* - sekcja pozwalająca na zarządzanie zbiorami zdjęć.
2. *Images* - sekcja pozwalająca na zarządzanie pojedynczymi zdjęciami.
3. *Tag assignments* - sekcja pozwalająca na zarządzanie i wgląd w oznaczenia zdjęć.
4. *Tags* - sekcja pozwalająca na definiowanie dostępnych tagów.
5. *Classifier models* - sekcja zarządzania modelami klasyfikatora dostępnego w aplikacji.
6. *Patient file records* - sekcja pozwalająca na zarządzanie kartotekami pacjentów (wpisy z badań).
7. *Patient file profiles* - sekcja pozwalająca na zarządzanie profilami pacjentów.
8. *Grupy* - sekcja pozwalająca na zarządzanie grupami użytkowników.
9. *Użytkownicy* - sekcja pozwalająca na zarządzanie użytkownikami, ich hasłami oraz uprawnieniami.

== Logowanie
#figure(image("img_tagger_and_classificator/sign_in.png", width: 40%), caption: "Formularz logowania") \
Moduł logowania się do aplikacji jest jeden, spójny dla wszystkich podaplikacji. Pomyślne zalogowanie przyznaje dostęp do każdej podaplikacji. \

== Kartoteki pacjentów
Komponent kartoteki pacjentów to miejsce, w którym zarządzamy pacjentem oraz wpisami z badań. W tym miejscu lekarz może wstawić zdjęcie krtani pacjenta i wysłać je do analizy przez klasyfikator. 

#figure(image("img_tagger_and_classificator/kartoteka.png", width: 80%), caption: "Widok kartoteki pacjentów") \

=== Dodawanie nowego pacjenta do kartoteki
#figure(image("img_tagger_and_classificator/dodawanie_pacjentow.png", width: 80%), caption: "Dodawanie pacjenta") \

=== Usuwanie pacjenta z kartoteki
#figure(image("img_tagger_and_classificator/usuwanie_pacjenta.png", width: 80%), caption: "Usuwanie pacjenta ") \

=== Dodawanie rekordu do kartoteki pacjenta
// TODO
[JB: oczekuję na zrealizowaną funkcjonalność] \
[] \
[] \
[] \

=== Żądanie sklasyfikowania obiektu
// TODO
Lekarz dodając zdjęcie do kartoteki pacjenta (lekarz tworzy nowy rekord podczas wizyty) może zlecić jego sklasyfikowanie przy użyciu wybranego klasyfikatora. Podaplikacja kartoteki wysyła żądanie HTTP na stosowny endpoint klasyfikatora. Żądanie zawiera nazwę klasyfikatora oraz zdjęcie do sklasyfikowania (adres URL w chmurze R2). W odpowiedzi zwracany jest wynik klasyfikacji w postaci łańcucha znaków, który obrabia się celem estetycznej prezentacji w kartotece oraz zapisuje się go do bazy danych. \
[JB: tu obrazek] \
[] \
[] \
[] \

= Klasyfikator
== Włączenie do aplikacji, komunikacja podaplikacja - klasyfikator
Podjęto dezycję o zaimplementowaniu ramy klasyfikatora (w postaci usługi z endpointem), dzięki czemu podmiana modeli klasyfikatora jest możliwa a dalsze prace mogą być prowadzone bez przeszkód i przestojów z wykorzystaniem mock'owego klasyfikatora dopóki właściwy klasyfikator nie zostanie dostarczony. W ten sposób umożliwiliśmy pracę równoległą. Ustalono również wymogi związane z komunikacją między elementami systemu. \ 
Komunikacja z klasyfikatorem odbywa się za pomocą REST API. Klasyfikator przyjmuje adres w chmurze R2 obrazu do sklasyfikowania oraz nazwę modelu, który ma być użyty do klasyfikacji. Klasyfikator zwraca wynik klasyfikacji w postaci łańcucha znaków i zapisuje go wraz z danymi z kartoteki pacjenta do bazy danych PostgreSQL. Na końcu, gdy właściwy klasyfikator - binarny w etapie 1. - został dostarczony, podmieniono mock'owy klasyfikator na właściwy.

== Szczegóły techniczne klasyfikatora
Napisano skrypt w języku Python przeprowadzający klasyfikację binanrną zdjęć. Wykorzystano biblioteki TensorFlow oraz Keras. Wykorzystano również MobileNetV2 jako bazowy model do klasyfikacji ze względu na fakt szybkiego uczenia. 

=== Procedura uczenia klasyfikatora
1. Uruchomienie środowiska.
2. Wczytanie tagów z pliku CSV oraz zdjęć z chmury R2. Utworzenie krotek (tag, zdjęcie).
3. Odrzucenie krotek z informacją o nieczytelnym zdjęciu.
4. Podział krotek na 2 zbiory: krotki dla zdjęć zdrowych "zbiór zdrowy" i krotki dla zdjęć chorych "zbiór chory".
5. Przygotowanie zbioru treningowego i walidacyjnego. 
6. Obliczenie wag klas celem zbalansowania znacznej różnicy liczności zbiorów zdrowych i chorych.
7. Budowa modelu transfer learningowego MobileNetV2 wraz z podstawową data augmentation (tj. rotacja, flip, zoom, rescale).
8. Trening modelu.
9. Ewaluacja modelu na zbiorze walidacyjnym.
10. Zapis modelu do pliku.

== Osiągnięte rezultaty
Dane, którymi dysponujemy nie są liczne. Na moment pisania raportu zdjęć zdrowych jest ok. 20 a chorych ok. 80. Warto wspomnieć, że są to zdjęcia otagowane wielokrotnie, przez wielu lekarzy (otagowań jest 266). Wyniki nie są zadowalające, klasyfikator nie zwraca sensownych odpowiedzi. 

= Obsługa administratorska
== Zarządzanie profilami pacjentów
Administrator ma możliwość zarządzania profilami pacjentów. W tym celu może dodawać, edytować i usuwać profile pacjentów. \
#figure(image("img_tagger_and_classificator/administracja_kartoteka.png", width: 80%), caption: "Zarządzanie kartoteką przez administratora") \
#figure(image("img_tagger_and_classificator/admin_profil_pacjenta.png", width: 80%), caption: "Edycja profilu pacjenta przez administratora") \

== Zarządzanie rekordami pacjentów
Administrator ma możliwość zarządzania rekordami pacjentów. W tym celu może dodawać, edytować i usuwać rekordy pacjentów. \
#figure(image("img_tagger_and_classificator/admin_pacjent_zmiana_rekordu.png", width: 80%), caption: "Edycja rekordu przez administratora") \

== Zarządzanie klasyfikatorami
Zarząd nad dostępnymi klasyfikatorami pełni tylko administrator aplikacji. Może dodawać, usuwać lub wyłączyć korzystanie z klasyfikatora (usunąć go z listy rozwijanej) w widoku rekordu pacjenta. Administrator dba o to, aby podaplikacja kartoteki pacjentów współistniała z klasyfikatorem na polu oferowanych funkcjonalności. \

#figure(image("img_tagger_and_classificator/admin_klasyfikatory.png", width: 80%), caption: "Lista wszystkich dodanych klasyfikatorów") \
Dodając klasyfikator, zapisuje się jego nazwę, opis oraz adres URL endpointu klasyfikatora, na który wysyła się obraz do klasyfikacji. \
#figure(image("img_tagger_and_classificator/admin_dodawanie_klasyfikatora.png", width: 80%), caption: "Dodawanie nowego klasyfikatora") \
 