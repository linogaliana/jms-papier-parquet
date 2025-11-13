
// This is an example typst template (based on the default template that ships
// with Quarto). It defines a typst function named 'article' which provides
// various customization options. This function is called from the 
// 'typst-show.typ' file (which maps Pandoc metadata function arguments)
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-show.typ' entirely. You can find 
// documentation on creating typst templates and some examples here: 
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates

#let article(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: none,
  resume: none,
  cols: 1,
  margin: (x: 25mm, y: 25mm),
  paper: "a4",
  header: (),
  footer: none,
  lang: "fr",
  region: "FR",
  font: "libertinus serif",
  fontsize: 10pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  keywords: (),
  domains: (),
  heading-family: "libertinus serif",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  sectionnumbering: "1.1.1",
  pagenumbering: "1",
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {
  set page(
    paper: paper,
    margin: margin,
    numbering: pagenumbering,
    background: none,
    footer: context {
      let page-number = counter(page).get().first()
      set text(size: 0.9em)

      // sur les pages paires (pages de gauche),
      // on affiche le numéro de page avant le pied de page
      if calc.even(page-number){
        [#counter(page).display("1")]
      }
      
      text(size: 0.9em)[#h(1fr) #footer #h(1fr)]
      
      // sur les pages impaires (pages de droite),
      // on affiche le numéro de page après le pied de page
      if calc.odd(page-number){
        [#counter(page).display("1")]
      }
    }
  )

  set enum(indent: 2em)
  set list(indent: 2em)

  set heading(numbering: sectionnumbering)
  show heading: set text(size: 1.1em)
  show heading.where(level: 1): set block(below: 1.2em, above: 1.6em)
  show heading.where(level: 2): set block(below: 1.2em, above: 1.6em)

  

  set par(justify: true, leading: 0.8em, spacing: 1.5em)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)

  //show heading.where(level: 1): set text(size: 1em)
  //show heading.where(level: 2): set text(size: 1.1em)
  //show heading.where(level: 3): set text(size: 1em)
  show footnote: set text(size: 1.2em) // taille de l'appel de note dans le corps du texte
  set footnote.entry(indent: 0em) // indentation dans la note de bas de page
  // modifie les tailles dans la note de bas de page
  show footnote.entry: it => {
    let loc = it.note.location()
    // taille de l'appel de note
    text(size: 1.2em)[#super[#numbering(
      "1",
      ..counter(footnote).at(loc),
    )]]
    // taille du texte
    text(size: 0.8em)[#it.note.body]
  }

  if header.len() > 0 {
    align(header.location,  image(header.path, width: header.width, alt: header.alt))
  }
  
  if title != none {
    align(center)[#block(inset: 1em)[
      #set par(leading: heading-line-height)
      #if (heading-family != none or heading-weight != "bold" or heading-style != "normal"
           or heading-color != black) {
        set text(font: heading-family, weight: heading-weight, style: heading-style, fill: heading-color, hyphenate: false)
        text(size: title-size)[#smallcaps[#title]]
        if subtitle != none {
          parbreak()
          text(size: subtitle-size)[#subtitle]
        }
      } else {
        text(weight: "bold", size: title-size)[#smallcaps[#title]]
        if subtitle != none {
          parbreak()
          text(weight: "bold", size: subtitle-size)[#subtitle]
        }
      }
    ]]
  }

  if authors != none {

    let count = authors.len()
    // crée des étoiles pour référencer les auteurs, exemple : (**)
    let authors = authors.enumerate(start: 1).map(it => {
        let (position, author) = it
        let stars = "(" + range(position).map(it => "*").join() + ")"
        author.insert("stars", stars)
        author
      })

    emph(align(center)[
      #set text(size: 1.1em, hyphenate: false)
      #authors.map(author => {
        let (name, stars, ) = author
        name + " " + stars
      }).join(", ") \ 
      
      #for author in authors {
        [#author.stars #author.affiliation \ ]
      }
      
      #authors.map(author => {
        let (email, ) = author
        email
      }).join(" ")
    ])
  }

  v(15pt)


  let capitalize(text) = upper(text.first()) + text.clusters().slice(1).join()
  let capitalize-first-word(arr) = {
    let capitalized-first-word = capitalize(arr.remove(1))
    arr.insert(0, capitalized-first-word)
    arr
  }


    if keywords.len() > 0 {
    block[
      #set par(justify: false)
      #set text(size: 0.95em)
      #strong[Mots-clés] : #if type(keywords) == array {
        capitalize-first-word(keywords).join(", ")
      } else {
        capitalize(keywords)
      }
    ]
  }

  if domains.len() > 0 {
    block[
      #set par(justify: false)
      #set text(size: 0.95em)
      #strong[Domaines] : #if type(domains) == array {
        capitalize-first-word(domains).join(", ")
      } else {
        capitalize(domains)
      }
    ]
  }

  if date != none {
    align(center)[#block(inset: 1em)[
      #date
    ]]
  }

  v(30pt)

  if resume != none {

    block[
      #text(weight: "semibold", size: 1.2em)[Résumé] \ 
      #v(3pt) 
      #text(size: 0.9em)[#resume]
      #v(8pt) 
    ]
  }

  if abstract != none {
    block[
      #text(weight: "semibold", size: 1.2em)[#abstract-title] \ 
      #v(3pt) 
      #text(size: 0.9em)[#abstract]
      #v(8pt) 
    ]
  }


  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
  }
  
  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

#set table(
  inset: 6pt,
  stroke: none,
)
#show table.cell.where(y: 0): strong
#show table.cell: set text(size: 0.8em)

#show link: set text(rgb("#00b3f0"))

#show cite: it => {
    show regex("\d{4}"): set text(blue)
    it
}


#show figure.where(
): set figure(scope: "parent", placement: auto)

#show figure: set text(size: 0.9em)
#show figure: set block(inset: (bottom: 0.2em))

#let titled-raw-block(body, filename: none) = {
  if (filename != none) {
    block(
      inset: (left: 2em, top: 1em, bottom: 1em),
      fill: white
    )[      
    #block(
      inset: 0em,
      fill: luma(200),
      radius: 8pt,
      outset: 0.75em,
      width: 90%,
      spacing: 2em,
      [
        #text(size: 0.8em)[#filename]
        #block(
          fill: luma(230),
          inset: 0em, 
          above: 1.2em, 
          outset: 0.75em, 
          radius: (bottom-left: 8pt, bottom-right: 8pt), 
          width: 100%,
          body
        )
      ]
    )
    ]
  } else {
    body
  }
}
