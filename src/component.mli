(** This module provides functions to create component class.
    Each of function creates another type of component, you should select a type to create what you want.
*)

module type Props = sig
  type t
end

(** [make_stateless ~props ~render] make the component that is stateless *)
val make_stateless:
  props:(module Props with type t = 'p)
  -> render:('p Js.t -> Core.React.element Js.t)
  -> ('p, unit, unit) Core.React.component

(** [make_stateful ~props ~spec] make the component with state *)
val make_stateful:
  props:(module Props with type t = 'p)
  -> spec:('p, 'state, unit) Core.Component_spec.t
  -> ('p, 'state, unit) Core.React.component

(** [make_stateful_with_custom ~props ~spec] make the component with state and custom *)
val make_stateful_with_custom:
  props:(module Props with type t = 'p)
  -> spec:('p, 'state, 'custom) Core.Component_spec.t
  -> ('p, 'state, 'custom) Core.React.component
