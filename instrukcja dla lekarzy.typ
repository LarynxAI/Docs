#import "@preview/note-me:0.3.0": *
#import "@preview/tablex:0.0.9": tablex, rowspanx, colspanx
#show link: underline
#let insa-short(
  author : none,
  date : none,
  doc
) = {
  set text(lang: "pl")
  set page(
    "a4",
    margin: (top: 3cm, bottom: 2cm, left: 1cm, right:1cm),
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
    footer: [
      #place(
        right,
        dx: 1.55cm,
        dy: 0.58cm,
        text(fill: black, weight: 0, font: "Cascadia Code", fallback: false, [#counter(page).display()])
      )
    ]
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
W celu stworzenia zbioru oznaczonych zdjęć laryngoskopowych, stworzyliśmy aplikację webową, która pozwala na przeglądanie zdjęć oraz ich oznaczanie. W niniejszym dokumencie przedstawiamy funkcjonalności aplikacji oraz sposób korzystania z niej.

= Panel użytkownika
Aplikacja znajduje się pod adresem #link("http://srv10.mikr.us:20381/"). Domyślnie niezalogowany użytkownik (np. w trakcie pierwszego wejścia na stronę) jest przekierowany na stronę rejestracji #link("http://srv10.mikr.us:20381/join/"). Można na niej stworzyć konto albo przejść do logowania - w tym celu należy kliknąć `Log in here!` (rys. 1). 

== Rejestracja
Aby zarejestrować się w aplikacji, należy wypełnić formularz rejestracyjny, znajdujący się pod adresem #link("http://srv10.mikr.us:20381/join/"). W formularzu trzeba podać kod zaproszenia, adres e-mail oraz stworzyć hasło. Następnie, aby dokończyć rejestrację, należy kliknąć przycisk "Sign up" (rys. 1).

#figure(image("img_pl/join.png", width: 32%), caption: "Formularz rejestracji")

== Logowanie
Po utworzeniu konta można się zalogować do aplikacji. Ekran logowania znajduje się pod adresem #link("http://srv10.mikr.us:20381/login/"). Kod zaproszenia nie jest już wymagany. W formularzu logowania należy podać adres e-mail oraz hasło podane podczas rejestracji, a następnie kliknąć przycisk "Sign in" (rys. 2).
#figure(image("img_pl/sign_in.png", width: 35%), caption: "Formularz logowania")

== Lista zbiorów danych
Po zalogowaniu użytkownikowi wyświetlana jest lista zbiorów danych, które są dostępne do oznaczenia. Każdy zbiór danych zawiera informacje o nazwie, opisie oraz liczbie zdjęć. Aby przejść do oznaczania zdjęć, należy kliknąć nazwę wybranego zbioru. Jeżeli zajdzie potrzeba dodania nowego zbioru danych, można to zrobić poprzez kliknięcia *+* w prawym dolnym rogu ekranu. Aplikacja poprosi o podanie kodu zaproszenia do nowego zbioru.

#figure(
  image("img_pl/datasets.png", width: 100%),
  caption: "Widok listy zbiorów danych"
)

== Oznaczanie zdjęć
Po przejściu do wybranego zbioru danych można rozpocząć oznaczanie zdjęć. W górnej części widoku prezentowany jest pasek postępu oznaczania oraz przycisk przejścia do widoku historii oznaczeń. W centralnej części, po lewej stronie, prezentowany jest obraz wraz z kontrolkami regulacji pozycji i powiększenia. Po prawej stronie widoczna jest lista dostępnych oznaczeń wraz z kryteriami, jakie powinno spełnić zdjęcie, by wybrać dane oznaczenie. Jeżeli klasyfikacja jest możliwa, należy wybrać odpowiednie oznaczenie z listy a następnie kliknąć `Submit`. 

#figure(
  image("img_pl/dataset_tagging.png", width: 90%),
  caption: "Widok oznaczania zdjęć"
)

Jeżeli klasyfikacja nie jest możliwa, ze względu na niejednoznaczność obrazu albo złą jakość zdjęcia należy wybrać opcję `Unclassifiable`. Wybranie tej opcji wiąże się z koniecznością uzasadnienia swojej decyzji w oknie tekstowym, które się pojawi. Po napisaniu uzasadnienia można wcisnąć przycisk `Mark as unclassifiable` aby przejść do dalszego oznaczania zdjęć.

#figure(
  image("img_pl/unclassifiable.png", width: 70%),
  caption: "Okno uzasadnienia decyzji o nieklasyfikowalności"
)

= Panel administracyjny
Aplikacja posiada panel administracyjny, który pozwala na zarządzanie użytkownikami, zdjęciami oraz oznaczeniami. Panel ten jest dostępny pod adresem `http://srv10.mikr.us:20381/admin` i wymaga zalogowania się za pomocą konta administratora.
#figure(
	image("img_pl/logowanie.png", width: 40%),
	caption: "Logowanie do panelu administracyjnego"
)

#figure(
	image("img_pl/admin_zalogowany.png", width: 40%),
	caption: "Sekcje panelu administracyjnego"
)

Po zalogowaniu widocznych jest 6 sekcji:
1. *Groups* - sekcja pozwalająca na zarządzanie grupami użytkowników (obecnie nie używana)
2. *Users* - sekcja pozwalająca na zarządzanie użytkownikami, ich hasłami oraz uprawnieniami
3. *Datasets* - sekcja pozwalająca na zarządzanie zbiorami zdjęć
4. *Images* - sekcja pozwalająca na zarządzanie pojedynczymi zdjęciami
5. *Tag assignments* - sekcja pozwalająca na zarządzanie i wgląd w oznaczenia zdjęć
6. *Tags* - sekcja pozwalająca na definiowanie dostępnych tagów

== Przesyłanie zbioru obrazów do oznaczenia
Aby utworzyć i przesłać zbiór danych (obrazów) do oznaczania, należy przejść do sekcji *Datasets* i kliknąć przycisk *Add dataset*.
#figure(
  image("img_pl/add_datasets.png", width: 80%),
  caption: "Widok listy zbiorów danych"
)

Następnie należy podać:
1. Nazwę zbioru danych
2. Opis zbioru danych
3. Tagi dostępne dla zbioru danych
  - Tagi można dodawać i usuwać z poziomu sekcji *Tags* lub klikając zielony przycisk +.

Oraz przesłać (pojedynczo przyciskiem _Add another Image_ lub zbiorowo poprzez sekcję _Bulk upload_) obrazy do oznaczenia.

#figure(
  image("img_pl/add_dataset_form.png", width: 80%),
  caption: "Widok listy zbiorów danych"
)

Pole *Doctor invite code* zawiera unikalny kod, pozwalający na dostęp do zbioru danych. Należy go przekazać lekarzowi, który ma oznaczyć zdjęcia.

Na koniec należy kliknąć przycisk *Save*. Zbiór danych zostanie dodany do listy zbiorów danych.

Nie jest wymagane ręczne tworzenie kont użytkowników. Lekarz, który otrzyma kod zaproszenia, może zarejestrować się samodzielnie, podając kod w formularzu rejestracyjnym.
