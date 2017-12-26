module Core = Roo_core

type tags = [
  | `span
  | `div
  | `ul
  | `li
  | `section
  | `header
  | `footer
  | `table
  | `tbody
  | `thead
  | `td
  | `th
  | `colgroup
  | `col
  | `tfoot
] [@@deriving variants]

let of_tag ?prop ?(children=[||]) tag = Core.create_dom_element ?prop ~children @@ Variants_of_tags.to_name tag
