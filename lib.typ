#let rotateChar = "[-ー\u{FF5E}\u{301C}\p{Open_Punctuation}\p{Close_Punctuation}]"
#let vw(
  body,
  kerning: 0.3em,
  leading: 0.5em,
  spacing: 1em,
) = {
  set align(right)
  stack(
    dir: rtl,
    spacing: leading,
    ..for s in body.split(regex("[\n]")) {
      (
        stack(
          dir: ttb,
          spacing: spacing,
          ..for t in s.split(regex("[\p{Zs}]")) {
            (
              stack(
                dir: ttb,
                spacing: kerning,
                ..for l in t.clusters() {
                  (
                    if regex(rotateChar) in l {
                      set align(center)
                      rotate(90deg, l)
                    } else {
                      set align(center)
                      l
                    },
                  )
                },
              ),
            )
          },
        ),
      )
    },
  )
}

#let formatAddress(address) = {
  address.replace("-", "ー").replace("1", "一").replace("2", "二").replace("3", "三").replace("4", "四").replace("5", "五").replace("6", "六").replace("7", "七").replace("8", "八").replace("9", "九").replace("0", "〇")
}

#let hagaki(lastName, firstName, postCode, address, myLastName, myFirstName, myPostCode, myAddress, debug: false) = {
  set page(width: 100mm, height: 148mm, margin: 0mm)
  if debug == true {
    set page(background: image("hagaki.png"))
  }

  // postCode

  set text(size: 16pt)
  for (i, c) in postCode.clusters(
  ).filter(x => regex("[0-9]") in x).enumerate() {
    place(
      top + left,
      block(
        align(center + horizon)[#c],
        width: 6mm,
        height: 8mm,
      ),
      dx: i * 7mm + 44mm,
      dy: 12mm,
    )
  }

  // myPostCode

  set text(size: 10pt)
  for (i, c) in myPostCode.clusters(
  ).filter(x => regex("[0-9]") in x).enumerate() {
    place(
      top + left,
      block(
        align(center + horizon)[#c],
        width: 4mm,
        height: 6.5mm,
      ),
      dx: i * 4.1mm + 5.7mm,
      dy: 122.5mm,
    )
  }

  // name

  set text(size: 30pt)
  place(
    center + bottom,
    block(
      vw(lastName + " " + firstName + " 様"),
    ),
    dy: -33mm,
  )

  // address

  set text(size: 13pt)
  place(
    top + right,
    block(
      vw(formatAddress(address)),
      width: 35mm,
      height: 90mm,
    ),
    dy: 30mm,
    dx: -10mm,
  )

  // myAddress

  place(
    left + top,
    block(
      align(center + horizon)[
        #set text(size: 10pt)
        #vw(formatAddress(myAddress))
      ],
      width: 15mm,
      height: 60mm,
    ),
    dx: 15mm,
    dy: 60mm,
  )

  // myName

  place(
    left + top,
    block(
      align(center + bottom)[
        #set text(size: 16pt)
        #vw(myLastName + " " + myFirstName)
      ],
      width: 10mm,
      height: 60mm,
    ),
    dx: 5mm,
    dy: 60mm,
  )
  pagebreak(weak: true)
}

#let hagakiBatch(
  path,
  lastNameColumn,
  firstNameColumn,
  postCodeColumn,
  addressColumn,
  myLine: 1,
  debug: false,
) = {
  let lines = csv(path)
  for (i, line) in lines.slice(1).enumerate() {
    if i + 1 == myLine {
      continue
    }
    hagaki(
      line.at(lastNameColumn),
      line.at(firstNameColumn),
      line.at(postCodeColumn),
      line.at(addressColumn),
      lines.at(myLine).at(lastNameColumn),
      lines.at(myLine).at(firstNameColumn),
      lines.at(myLine).at(postCodeColumn),
      lines.at(myLine).at(addressColumn),
      debug: false,
    )
  }
}
