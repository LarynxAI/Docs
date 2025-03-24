#import "@preview/note-me:0.3.0": *
#import "@preview/tablex:0.0.9": tablex, rowspanx, colspanx
#set page(numbering: "1")

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
    footer: [
      #place(
        right,
        dx: 0cm,
        dy: 0.58cm,
        context(text(fill: black, font: "Cascadia Code", [strona #counter(page).display()]))

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
#align(center, text(size: 21pt, weight: "bold", smallcaps("Nazwa dokumentu")))
#align(center, text(size: 12pt, weight: "bold", smallcaps("Podtytuł dokumentu")))
#v(5pt)

#align(center, [
		#table(
  		columns: 2,
  		[Wersja], [1.0],
  		[Data pierwszego sporządzenia], [xx.xx.20xx],
			[Utworzył], [imię i nazwisko],
  		[Data ostatniej aktualizacji], [xx.xx.20xx],
  		[Autor ostatniej zmiany], [imię i nazwisko]
		)
	])

#set heading(numbering: "1.")
/*#show heading.where(level: 2): it => [
  #counter(heading).display()
  #text(weight: "medium", style: "italic", size: 13pt, it.body)
]*/
#label("Spis treści")
#outline(title: "Spis treści", indent:  n => 1em * n, depth: 3)
= Rodział 1
Treść.
1. *Wyróżnik punktu* - opis punktu.
2. *Wyróżnik punktu* - opis punktu.
3. *Wyróżnik punktu* - opis punktu.

= Rodział 2
Treść
#figure(
	image("img/template_picture.png", width: 50%),
	caption: "Przykładowy rysunek"
)

#pagebreak()