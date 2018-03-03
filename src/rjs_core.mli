(* the module for low-level binding for React *)
module React : sig
  type element
  class type defined_props = object
    method children: element Js.t Js.js_array Js.t Js.readonly_prop
  end

  class type ['props, 'state] stateful_component =
    object
      method props : 'props Js.readonly_prop
      method props_defined: defined_props Js.t Js.readonly_prop
      method setState : 'state -> unit Js.meth
      method state : 'state Js.prop
      method nodes : Dom_html.element Js.t Jstable.t Js.prop
    end

  type ('props, 'state) component

end

module E = Jsoo_reactjs_event

module Element_spec : sig
  type 'a t = {
    key: string option;
    class_name: string option;
    on_key_down: (E.Keyboard_event.t -> unit) option;
    on_key_press: (E.Keyboard_event.t -> unit) option;
    on_key_up: (E.Keyboard_event.t -> unit) option;
    on_change: (E.Input_event.t -> unit) option;
    on_input: (E.Input_event.t -> unit) option;
    default_value: string option;
    others: (< .. > as 'a) Js.t option;
  }
end

val element_spec:
  ?key:string ->
  ?class_name:string ->
  ?on_key_down:(E.Keyboard_event.t -> unit) ->
  ?on_key_press:(E.Keyboard_event.t -> unit) ->
  ?on_key_up:(E.Keyboard_event.t -> unit) ->
  ?on_change:(E.Input_event.t -> unit) ->
  ?on_input:(E.Input_event.t -> unit) ->
  ?default_value:string ->
  ?others:(< .. > as 'a) Js.t ->
  unit -> 'a Element_spec.t

(* The module providing component spec to be able to create component via React API.
   Some of fields are optional and omit if you do not need their.
*)
module Component_spec : sig
  type ('props, 'state) constructor =
    ('props Js.t, 'state Js.t) React.stateful_component Js.t -> 'props Js.t -> unit

  type ('props, 'state) render =
    ('props Js.t, 'state Js.t) React.stateful_component Js.t -> React.element Js.t

  type ('props, 'state, 'result) component_update_handler =
    ('props Js.t, 'state Js.t) React.stateful_component Js.t -> 'props Js.t -> 'state Js.t -> 'result

  type ('props, 'state) component_will_receive_props =
    ('props Js.t, 'state Js.t) React.stateful_component Js.t -> 'props Js.t -> unit

  type ('props, 'state) lifecycle_handler =
    ('props Js.t, 'state Js.t) React.stateful_component Js.t -> unit

  type ('props, 'state) t = {
    constructor : ('props, 'state) constructor option;
    render : ('props, 'state) render;
    should_component_update : ('props, 'state, bool) component_update_handler option;
    component_will_receive_props : ('props, 'state) component_will_receive_props option;
    component_will_mount : ('props, 'state) lifecycle_handler option;
    component_will_unmount : ('props, 'state) lifecycle_handler option;
    component_did_mount : ('props, 'state) lifecycle_handler option;
    component_will_update : ('props, 'state, unit) component_update_handler option;
    component_did_update : ('props, 'state, unit) component_update_handler option;
  }
end

val component_spec:
  ?constructor:('props, 'state) Component_spec.constructor ->
  ?should_component_update:('props, 'state, bool) Component_spec.component_update_handler ->
  ?component_will_receive_props:('props, 'state) Component_spec.component_will_receive_props ->
  ?component_will_mount:('props, 'state) Component_spec.lifecycle_handler ->
  ?component_will_unmount:('props, 'state) Component_spec.lifecycle_handler ->
  ?component_did_mount:('props, 'state) Component_spec.lifecycle_handler ->
  ?component_will_update:('props, 'state, unit) Component_spec.component_update_handler ->
  ?component_did_update:('props, 'state, unit) Component_spec.component_update_handler ->
  ('props, 'state) Component_spec.render ->
  ('props, 'state) Component_spec.t

(** Create stateful component with spec *)
val create_stateful_component : ('p, 's) Component_spec.t -> ('p, 's) React.component

(** Create stateless component with renderer *)
val create_stateless_component : ('p Js.t -> React.element Js.t) -> ('p, unit) React.component

(** Create element with component *)
val create_element : ?key:string ->
  ?props:(< .. > as 'a) Js.t -> ?children:React.element Js.t array ->
  ('a, 'b) React.component -> React.element Js.t

(** Create element with tag *)
val create_dom_element: ?key:string ->
  ?_ref:(Dom_html.element Js.t -> unit) ->
  ?props:'a Element_spec.t -> ?children:React.element Js.t array ->
  string -> React.element Js.t

(** Create Fragment component to wrap empty dom *)
val fragment: ?key:string -> React.element Js.t array -> React.element Js.t

(** Create element for text node *)
val text: string -> React.element Js.t

(** Create empty element when you want not to create any element. *)
val empty: unit -> React.element Js.t
