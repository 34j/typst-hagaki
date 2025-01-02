#let rotateChar = "[-ー\u{FF5E}\u{301C}\p{Open_Punctuation}\p{Close_Punctuation}]"
#let vw( body, 
        kerning: 0.3em, leading: 0.5em, spacing: 1em, ) = {
  set align(right)
  stack( dir: rtl, spacing: leading,
    ..for s in body.split(regex("[\n]")) {
      (
        stack(dir: ttb, spacing: spacing,
          ..for t in s.split(regex("[\p{Zs}]")) {
            (
              stack( dir: ttb, spacing: kerning,
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
                }
              ),
            )
          }
        ),
      )
    }
  )
}


#let hagaki(lastName, firstName, postCode, address, myLastName, myFirstName, myPostCode, myAddress, debug: false) = {
  set page( width: 100mm, height: 148mm, margin: 0mm)
  if debug == true {
    set page(background: image("hagaki.png"))
  }
  set text(size: 16pt)

  for (i, c) in postCode.clusters(
).enumerate() {
    place(
      top + left,
      block(
        align(center + horizon)[#c],
        width: 6mm, height: 8mm
      ),
      dx: i * 7mm + 44mm,
      dy: 12mm,
    )
  }

  set text(size: 10pt)
for (i, c) in myPostCode.clusters(
).enumerate() {
    place(
      top + left,
      block(
        align(center + horizon)[#c],
        width: 4mm, height: 6.5mm
      ),
      dx: i * 4.1mm + 5.7mm,
      dy: 122.5mm,
    )
  }

  set text(size: 30pt)
  place(
    center + bottom,
    block(
      vw(lastName + " " + firstName + " 様")
    ),
    dy: -33mm,
  )

  set text(size: 16pt)
  place(
    top + right,
    block(
      vw(address.replace("-", "ー")),
      width: 35mm,
      height: 90mm,
    ),
    dy: 30mm,
    dx: -5mm,
  )
  
  place(
    left+top,
    block(
      align(center + horizon)[
        #set text(size: 10pt)
        #vw(myAddress.replace("-", "ー"))
      ] 
      ,
      width: 20mm,
      height: 60mm,
    ),
    dx: 15mm,
    dy: 60mm,
  )
place(
    left+top,
    block(
      align(center + bottom)[
        #set text(size: 16pt)
        #vw(myLastName + " " + myFirstName)
      ]
      ,
      width: 10mm,
      height: 60mm,
    ),
    dx: 5mm,
    dy: 60mm,
  )
  pagebreak(weak: true)
}
